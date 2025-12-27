ActiveAdmin.register SupportTicket do
  menu priority: 5, label: "Support Tickets", if: proc { true }

  # actions :all, except: [:new, :edit, :destroy]

  index download_links: false, class: "admin-table w-full text-sm text-gray-800 bg-white rounded-xl overflow-hidden shadow" do
    selectable_column
    id_column
    column "User" do |ticket|
      link_to ticket.user&.email || "N/A", admin_user_path(ticket.user_id), class: "text-primary hover:text-primary-dark font-semibold"
    end
    column :subject
    column :category
    column "Created At" do |ticket|
      ticket.created_at&.strftime("%b %d, %Y at %I:%M %p")
    end
    column :status do |ticket|
      status_class = case ticket.status
      when 'open' then 'badge-status bg-red-100 text-red-800'
      when 'in_progress' then 'badge-status bg-yellow-100 text-yellow-800'
      when 'resolved' then 'badge-status bg-green-100 text-green-800'
      else 'badge-status bg-gray-100 text-gray-800'
      end
      content_tag(:span, ticket.status.titleize, class: status_class)
    end
    actions defaults: false do |ticket|
      content_tag :div, class: "flex items-center gap-2" do
        safe_join([
          link_to("View", admin_support_ticket_path(ticket), class: "btn-primary text-xs px-3 py-1 rounded-md bg-primary hover:bg-primary-dark text-white"),
          link_to("Delete", admin_support_ticket_path(ticket), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-3 py-1 rounded-md bg-red-500 text-white hover:bg-red-700")
        ])
      end
    end
  end

  show title: proc { |ticket| "Ticket ##{ticket.id} - #{ticket.subject}" } do
    div class: "max-w-3xl mx-auto bg-white rounded-xl shadow p-8 space-y-6" do
      attributes_table_for resource do
        row :id
        row :user_id
        row :subject
        row :category
        row :description
        row :status
        row :created_at
        row :updated_at
      end
      div class: "flex gap-4 mt-8" do
        span do
          link_to "Delete", admin_support_ticket_path(resource), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-4 py-2 rounded-md bg-red-500 text-white hover:bg-red-700"
        end
      end
    end
  end

end
