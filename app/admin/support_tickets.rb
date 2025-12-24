ActiveAdmin.register SupportTicket do
  menu priority: 5, label: "Support Tickets", if: proc { true }

  # actions :all, except: [:new, :edit, :destroy]

  index do
    selectable_column
    id_column
    column :user_id
    column :subject
    column :category
    column :created_at
    column :status
    actions
  end

  show title: proc { |ticket| "Ticket ##{ticket.id} - #{ticket.subject}" } do
    div class: "mx-auto max-w-7xl p-4 pb-20 md:p-6 md:pb-6" do
      div class: "flex flex-wrap items-center justify-between gap-3 pb-6" do
        h2 class: "text-xl font-semibold text-gray-800 dark:text-white/90" do
          "Ticket Reply"
        end
        nav do
          ol class: "flex items-center gap-1.5" do
            li do
              a href: admin_support_tickets_path, class: "inline-flex items-center gap-1.5 text-sm text-gray-500 dark:text-gray-400" do
                span { "Home" }
                span { raw('<svg class="stroke-current" width="17" height="16" viewBox="0 0 17 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6.0765 12.667L10.2432 8.50033L6.0765 4.33366" stroke="" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"></path></svg>') }
              end
            end
            li class: "text-sm text-gray-800 dark:text-white/90" do
              "Ticket Reply"
            end
          end
        end
      end
      div class: "overflow-hidden xl:h-[calc(100vh-180px)]" do
        div class: "grid h-full grid-cols-1 gap-5 xl:grid-cols-12" do
          # Left: Main ticket conversation
          div class: "xl:col-span-8 2xl:col-span-9" do
            div class: "rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]" do
              div class: "flex flex-col justify-between gap-5 border-b border-gray-200 px-5 py-4 sm:flex-row sm:items-center dark:border-gray-800" do
                div do
                  h3 class: "text-lg font-medium text-gray-800 dark:text-white/90" do
                    "Ticket ##{resource.id} - #{resource.subject}"
                  end
                  para class: "text-sm text-gray-500 dark:text-gray-400" do
                    l(resource.created_at, format: :long)
                  end
                end
                div class: "flex items-center gap-4" do
                  para class: "text-sm text-gray-500 dark:text-gray-400" do
                    "ID: #{resource.id}"
                  end
                end
              end
              div class: "relative px-6 py-7" do
                div class: "space-y-7 divide-y divide-gray-200 dark:divide-gray-800" do
                  # Main ticket message
                  div do
                    div class: "mb-6 flex items-center gap-3" do
                      span class: "h-10 w-10 shrink-0 rounded-full bg-gray-200 flex items-center justify-center text-gray-500 font-bold" do
                        resource.user&.name&.first&.upcase || "U"
                      end
                      div do
                        para class: "text-sm font-medium text-gray-800 dark:text-white/90" do
                          resource.user&.name || "-"
                        end
                        para class: "text-xs text-gray-500 dark:text-gray-400" do
                          resource.user&.email || "-"
                        end
                      end
                    end
                    div class: "pb-6" do
                      para class: "text-sm text-gray-500 dark:text-gray-400" do
                        resource.description
                      end
                    end
                  end
                  # (Optional) Admin reply form placeholder
                  div class: "pt-5" do
                    div class: "mx-auto max-h-[162px] w-full rounded-2xl border border-gray-200 shadow-xs dark:border-gray-800 dark:bg-gray-800" do
                      textarea class: "h-20 w-full resize-none border-none bg-transparent p-5 font-normal text-gray-800 outline-none placeholder:text-gray-400 focus:ring-0 dark:text-white", placeholder: "Type your reply here..."
                      div class: "flex items-center justify-between p-3" do
                        button class: "flex h-9 items-center gap-1.5 rounded-lg bg-transparent px-2 py-3 text-sm text-gray-500 hover:bg-gray-100 hover:text-gray-700 dark:text-gray-400 dark:hover:bg-gray-900 dark:hover:text-gray-300" do
                          raw('<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"><path d="M14.4194 11.7679L15.4506 10.7367C17.1591 9.02811 17.1591 6.25802 15.4506 4.54947C13.742 2.84093 10.9719 2.84093 9.2634 4.54947L8.2322 5.58067M11.77 14.4172L10.7365 15.4507C9.02799 17.1592 6.2579 17.1592 4.54935 15.4507C2.84081 13.7422 2.84081 10.9721 4.54935 9.26352L5.58285 8.23002M11.7677 8.23232L8.2322 11.7679" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path></svg>')
                          span { "Attach" }
                        end
                        button class: "bg-brand-500 hover:bg-brand-600 shadow-theme-xs inline-flex h-9 items-center justify-center rounded-lg px-4 py-3 text-sm font-medium text-white" do
                          "Reply"
                        end
                      end
                    end
                  end
                  # Status
                  div class: "mt-6 flex flex-wrap items-center gap-4" do
                    span class: "text-gray-500 dark:text-gray-400" do
                      "Status:"
                    end
                    span class: "inline-block rounded-full px-2 py-0.5 font-medium bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-300 text-theme-xs" do
                      case resource.status
                      when 'open', 'in_progress'
                        "In Progress"
                      when 'resolved', 'closed'
                        "Solved"
                      else
                        resource.status.titleize
                      end
                    end
                  end
                end
              end
            end
          end
          # Right: Ticket details
          div class: "mt-6 xl:col-span-4 2xl:col-span-3" do
            div class: "rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]" do
              div class: "border-b border-gray-200 px-6 py-5 dark:border-gray-800" do
                h3 class: "text-lg font-medium text-gray-800 dark:text-white/90" do
                  "Ticket Details"
                end
              end
              ul class: "divide-y divide-gray-100 px-6 py-3 dark:divide-gray-800" do
                li class: "grid grid-cols-2 gap-5 py-2.5" do
                  span class: "text-sm text-gray-500 dark:text-gray-400" do
                    "Customer"
                  end
                  span class: "text-gray-700 dark:text-gray-400" do
                    resource.user&.name || "-"
                  end
                end
                li class: "grid grid-cols-2 gap-5 py-2.5" do
                  span class: "text-sm text-gray-500 dark:text-gray-400" do
                    "Email"
                  end
                  span class: "text-sm break-words text-gray-700 dark:text-gray-400" do
                    resource.user&.email || "-"
                  end
                end
                li class: "grid grid-cols-2 gap-5 py-2.5" do
                  span class: "text-sm text-gray-500 dark:text-gray-400" do
                    "Ticket ID"
                  end
                  span class: "text-sm text-gray-700 dark:text-gray-400" do
                    "##{resource.id}"
                  end
                end
                li class: "grid grid-cols-2 gap-5 py-2.5" do
                  span class: "text-sm text-gray-500 dark:text-gray-400" do
                    "Category"
                  end
                  span class: "text-sm text-gray-700 dark:text-gray-400" do
                    resource.category
                  end
                end
                li class: "grid grid-cols-2 gap-5 py-2.5" do
                  span class: "text-sm text-gray-500 dark:text-gray-400" do
                    "Created"
                  end
                  span class: "text-sm text-gray-700 dark:text-gray-400" do
                    l(resource.created_at, format: :long)
                  end
                end
                li class: "grid grid-cols-2 gap-5 py-2.5" do
                  span class: "text-sm text-gray-500 dark:text-gray-400" do
                    "Status"
                  end
                  div do
                    span class: "bg-blue-light-50 dark:bg-blue-light-500/15 dark:text-blue-light-500 text-theme-xs text-blue-light-500 inline-block rounded-full px-2 py-0.5 font-medium" do
                      case resource.status
                      when 'open', 'in_progress'
                        "In Progress"
                      when 'resolved', 'closed'
                        "Solved"
                      else
                        resource.status.titleize
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
