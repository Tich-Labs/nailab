# app/admin/resources.rb
#
# Main Resources admin page - manages all resources with categories
# Types: blog, event, webinar, opportunity, template, knowledge_hub
#
ActiveAdmin.register Resource do
  menu label: "Resources", priority: 6

  actions :all

  permit_params :title, :description, :content, :resource_type, :category,
                :author, :url, :published_at, :active

  filter :resource_type, as: :select, collection: ['blog', 'event', 'webinar', 'opportunity', 'template', 'knowledge_hub']
  filter :category, as: :select, collection: proc { Resource.pluck(:category).uniq.compact.sort }
  filter :author
  filter :active
  filter :published_at

  scope :all, default: true
  scope :blogs do |resources| resources.where(resource_type: 'blog') end
  scope :webinars do |resources| resources.where(resource_type: 'webinar') end
  scope :events do |resources| resources.where(resource_type: 'event') end
  scope :knowledge_hub do |resources| resources.where(resource_type: 'knowledge_hub') end
  scope :opportunities do |resources| resources.where(resource_type: 'opportunity') end
  scope :templates do |resources| resources.where(resource_type: 'template') end
  scope :published do |resources| resources.where(active: true) end
  scope :drafts do |resources| resources.where(active: false) end

  index do
    selectable_column
    column :title do |resource|
      link_to resource.title, admin_resource_path(resource), class: "text-primary hover:text-primary-dark"
    end
    column :resource_type do |resource|
      type_class = case resource.resource_type
      when 'blog' then 'bg-blue-100 text-blue-800'
      when 'webinar' then 'bg-green-100 text-green-800'
      when 'event' then 'bg-purple-100 text-purple-800'
      when 'opportunity' then 'bg-orange-100 text-orange-800'
      when 'knowledge_hub' then 'bg-indigo-100 text-indigo-800'
      when 'template' then 'bg-pink-100 text-pink-800'
      else 'bg-gray-100 text-gray-800'
      end
      span class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium capitalize #{type_class}" do
        resource.resource_type.titleize
      end
    end
    column :category
    column :author
    column :active do |resource|
      status_tag resource.active ? "Active" : "Inactive",
                 class: resource.active ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"
    end
    column :published_at do |resource|
      resource.published_at&.strftime('%B %d, %Y') || "—"
    end
    actions
  end

  show title: proc { |resource| resource.title } do
    div class: "mx-auto max-w-7xl p-4 pb-20 md:p-6 md:pb-6" do
      div class: "grid grid-cols-1 lg:grid-cols-3 gap-6" do
        # Main content
        div class: "lg:col-span-2 space-y-6" do
          div class: "bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 p-6" do
            h3 class: "text-lg font-semibold text-gray-900 dark:text-white mb-4" do "Content" end
            if resource.description.present?
              div class: "mb-4" do
                h4 class: "text-sm font-medium text-gray-700 dark:text-gray-300 mb-2" do "Description" end
                p class: "text-gray-600 dark:text-gray-400" do resource.description end
              end
            end
            if resource.content.present?
              div class: "prose prose-sm max-w-none dark:prose-invert" do
                resource.content.html_safe
              end
            end
          end
        end

        # Sidebar
        div class: "space-y-6" do
          div class: "bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 p-6" do
            h3 class: "text-lg font-semibold text-gray-900 dark:text-white mb-4" do "Details" end
            dl class: "space-y-3" do
              div do
                dt class: "text-sm font-medium text-gray-500 dark:text-gray-400" do "Type" end
                dd class: "mt-1" do
                  span class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium capitalize #{resource_type_badge(resource.resource_type)}" do
                    resource.resource_type.titleize
                  end
                end
              end
              if resource.category.present?
                div do
                  dt class: "text-sm font-medium text-gray-500 dark:text-gray-400" do "Category" end
                  dd class: "mt-1 text-sm text-gray-900 dark:text-white" do resource.category end
                end
              end
              if resource.author.present?
                div do
                  dt class: "text-sm font-medium text-gray-500 dark:text-gray-400" do "Author" end
                  dd class: "mt-1 text-sm text-gray-900 dark:text-white" do resource.author end
                end
              end
              if resource.url.present?
                div do
                  dt class: "text-sm font-medium text-gray-500 dark:text-gray-400" do "URL" end
                  dd class: "mt-1" do
                    a href: resource.url, target: "_blank", class: "text-primary hover:text-primary-dark text-sm" do resource.url end
                  end
                end
              end
              div do
                dt class: "text-sm font-medium text-gray-500 dark:text-gray-400" do "Status" end
                dd class: "mt-1" do
                  span class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{resource.active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}" do
                    resource.active ? "Active" : "Inactive"
                  end
                end
              end
              if resource.published_at.present?
                div do
                  dt class: "text-sm font-medium text-gray-500 dark:text-gray-400" do "Published At" end
                  dd class: "mt-1 text-sm text-gray-900 dark:text-white" do resource.published_at.strftime('%B %d, %Y at %I:%M %p') end
                end
              end
              div do
                dt class: "text-sm font-medium text-gray-500 dark:text-gray-400" do "Created" end
                dd class: "mt-1 text-sm text-gray-900 dark:text-white" do resource.created_at.strftime('%B %d, %Y at %I:%M %p') end
              end
              div do
                dt class: "text-sm font-medium text-gray-500 dark:text-gray-400" do "Updated" end
                dd class: "mt-1 text-sm text-gray-900 dark:text-white" do resource.updated_at.strftime('%B %d, %Y at %I:%M %p') end
              end
            end
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors
    div class: "mx-auto max-w-4xl p-4 pb-20 md:p-6 md:pb-6" do
      div class: "bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 p-6" do
        f.inputs "Resource Details" do
          f.input :title, required: true
          f.input :resource_type, as: :select, collection: ['blog', 'event', 'webinar', 'opportunity', 'template', 'knowledge_hub'], required: true
          f.input :category
          f.input :author
          f.input :description, as: :text
          f.input :content, as: :text, input_html: { rows: 10 }
          f.input :url
          f.input :published_at, as: :datetime_picker
          f.input :active
        end
        f.actions
      end
    end
  end

  controller do
    def scoped_collection
      super.includes(:ratings, :bookmarks)
    end
  end

  def resource_type_badge(type)
    case type
    when 'blog'
      'bg-blue-100 text-blue-800'
    when 'event'
      'bg-purple-100 text-purple-800'
    when 'webinar'
      'bg-green-100 text-green-800'
    when 'opportunity'
      'bg-yellow-100 text-yellow-800'
    when 'template'
      'bg-indigo-100 text-indigo-800'
    when 'knowledge_hub'
      'bg-pink-100 text-pink-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end