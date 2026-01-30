class Founder::ConversationsController < Founder::BaseController
  before_action :set_conversation, only: %i[show]

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

    @items = items.sort_by { |i| i[:updated_at] || Time.at(0) }.reverse

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
        @reading = []
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

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end
end
