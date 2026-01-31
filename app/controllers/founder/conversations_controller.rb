class Founder::ConversationsController < Founder::BaseController
  before_action :set_conversation, only: %i[show]
  before_action :set_selected_item, only: %i[create_message]

  def index
    # Gather conversations, support tickets and peer messages into a single list
    convs = current_user.conversations

    tickets = current_user.support_tickets.includes(:replies)

    sent = current_user.peer_messages
    received = current_user.received_peer_messages

    items = []

    convs.each do |c|
      items << {
        type: :conversation,
        id: c.id,
        subject: c.other_participant(current_user).name,
        contact: c.other_participant(current_user).name,
        category: nil,
        preview: nil,
        updated_at: c.updated_at,
        path: founder_conversation_path(c)
      }
    end

    tickets.each do |t|
      last = t.replies.order(:created_at).last
      items << {
        type: :support_ticket,
        id: t.id,
        subject: t.subject,
        contact: "Support Team",
        category: t.category,
        preview: (last&.body || t.description),
        updated_at: (last&.created_at || t.updated_at),
        path: founder_support_ticket_path(t)
      }
    end

    (sent + received).each do |m|
      other = m.sender_id == current_user.id ? User.find_by(id: m.recipient_id) : User.find_by(id: m.sender_id)
      items << {
        type: :peer_message,
        id: m.id,
        subject: nil,
        contact: other&.name || "Peer",
        category: nil,
        preview: m.content,
        updated_at: m.created_at,
        path: founder_peer_messages_path
      }
    end

    # compute counts before filtering
    grouped = items.group_by { |i| i[:type].to_s }
    @counts = {
      "all" => items.size,
      "conversation" => (grouped["conversation"] || []).size,
      "peer_message" => (grouped["peer_message"] || []).size,
      "support_ticket" => (grouped["support_ticket"] || []).size
    }

    @items = items.sort_by { |i| i[:updated_at] || Time.at(0) }.reverse

    # Server-side filter (persisted via URL)
    @filter = params[:filter]&.to_s || "all"
    if @filter.present? && @filter != "all"
      @items = @items.select { |it| it[:type].to_s == @filter }
    end

    # Selected item for reading panel (params override or default to first)
    selected_type = params[:selected_type]&.to_sym
    selected_id = params[:selected_id]&.to_i

    if selected_type && selected_id
      @selected_item = @items.find { |it| it[:type] == selected_type && it[:id] == selected_id }
    else
      @selected_item = @items.first
    end

    # Load reading content depending on selected item
    @reading = nil
    if @selected_item
      case @selected_item[:type]
      when :conversation
        conversation = current_user.conversations.find_by(id: @selected_item[:id])
        @reading = conversation ? conversation.messages.order(:created_at) : []
      when :support_ticket
        @reading = current_user.support_tickets.find(@selected_item[:id])
      when :peer_message
        @reading = PeerMessage.find_by(id: @selected_item[:id])
      end
    end
  end

  def show
    @messages = @conversation.messages
  end

  def create_message
    case @selected_item[:type]
    when :peer_message
      other_user_id = @reading.sender_id == current_user.id ? @reading.recipient_id : @reading.sender_id
      message = PeerMessage.create!(
        sender: current_user,
        recipient_id: other_user_id,
        content: params[:message_content]
      )

      # Broadcast to both sender and recipient
      Turbo::StreamsChannel.broadcast_append_to(
        "peer_messages_#{current_user.id}",
        target: "peer-messages-container",
        partial: "peer_message",
        locals: { message: message, current_user: current_user }
      )

      Turbo::StreamsChannel.broadcast_append_to(
        "peer_messages_#{other_user_id}",
        target: "peer-messages-container",
        partial: "peer_message",
        locals: { message: message, current_user: current_user }
      )

      # Notify recipient
      begin
        recipient = User.find(other_user_id)
        Notification.create!(user: recipient,
                 title: "New message from #{current_user.name}",
                 message: params[:message_content].truncate(100),
                 link: founder_conversations_path(selected_type: :peer_message, selected_id: message.id),
                 notif_type: "message")
      rescue => _e
        # ignore notification failures
      end

    when :conversation
      conversation = current_user.conversations.find_by(id: @selected_item[:id])
      message = conversation.messages.create!(
        sender: current_user,
        content: params[:message_content]
      )

      # Broadcast to both participants in the conversation
      Turbo::StreamsChannel.broadcast_append_to(
        "conversation_#{conversation.id}",
        target: "peer-messages-container",
        partial: "peer_messages/peer_message",
        locals: { message: message, current_user: current_user }
      )

    when :support_ticket
      reply = SupportTicketReply.create!(
        support_ticket_id: @selected_item[:id],
        user: current_user,
        body: params[:message_content]
      )

      # Broadcast to support ticket subscribers
      Turbo::StreamsChannel.broadcast_append_to(
        "support_ticket_#{@selected_item[:id]}",
        target: "support-replies-container",
        partial: "support_reply",
        locals: { reply: reply, current_user: current_user }
      )
    end

    redirect_to founder_conversations_path(selected_type: @selected_item[:type], selected_id: @selected_item[:id]), notice: "Message sent."
  rescue => e
    redirect_to founder_conversations_path(selected_type: @selected_item[:type], selected_id: @selected_item[:id]), alert: "Error sending message: #{e.message}"
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end

  def set_selected_item
    selected_type = params[:selected_type]&.to_sym
    selected_id = params[:selected_id]&.to_i

    convs = current_user.conversations
    tickets = current_user.support_tickets.includes(:replies)
    sent = current_user.peer_messages
    received = current_user.received_peer_messages

    items = []

    convs.each do |c|
      items << {
        type: :conversation,
        id: c.id,
        subject: c.other_participant(current_user).name,
        contact: c.other_participant(current_user).name,
        category: nil,
        preview: nil,
        updated_at: c.updated_at,
        path: founder_conversation_path(c)
      }
    end

    tickets.each do |t|
      last = t.replies.order(:created_at).last
      items << {
        type: :support_ticket,
        id: t.id,
        subject: t.subject,
        contact: "Support Team",
        category: t.category,
        preview: (last&.body || t.description),
        updated_at: (last&.created_at || t.updated_at),
        path: founder_support_ticket_path(t)
      }
    end

    (sent + received).each do |m|
      other = m.sender_id == current_user.id ? User.find_by(id: m.recipient_id) : User.find_by(id: m.sender_id)
      items << {
        type: :peer_message,
        id: m.id,
        subject: nil,
        contact: other&.name || "Peer",
        category: nil,
        preview: m.content,
        updated_at: m.created_at,
        path: founder_peer_messages_path
      }
    end

    @selected_item = items.find { |it| it[:type] == selected_type && it[:id] == selected_id }

    if @selected_item
      case @selected_item[:type]
      when :support_ticket
        @reading = current_user.support_tickets.find(@selected_item[:id])
      when :peer_message
        @reading = PeerMessage.find_by(id: @selected_item[:id])
      end
    end
  end
end
