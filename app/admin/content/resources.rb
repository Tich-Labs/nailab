# app/admin/content/resources.rb
ActiveAdmin.register Resource, namespace: :content do
    show title: proc { |resource| resource.title } do
      div class: "max-w-3xl mx-auto bg-white rounded-xl shadow p-8 space-y-6 text-align-left" do
        attributes_table_for resource do
          row :id
          row :title
                    row :resource_type do |resource|
            select_tag :resource_type,
              options_for_select([
                ['Blog', 'blog'],
                ['Event', 'event'],
                ['Webinar', 'webinar'],
                ['Opportunity', 'opportunity'],
                ['Template', 'template'],
                ['Knowledge Hub', 'knowledge_hub']
              ], resource.resource_type),
              disabled: true,
              class: "form-select w-48 bg-white text-gray-900 border-gray-300 rounded"
          end
          row :category
          row :author
          row :description
          row :content
          row :url
          row :published_at
          row :active
          row :created_at
          row :updated_at
        end
        div class: "flex gap-4 mt-8" do
          span do
            link_to "Edit", edit_content_resource_path(resource), class: "btn-secondary text-xs px-4 py-2 mr-2 rounded-md bg-accent text-white hover:bg-cyan-600"
          end
          span do
            link_to "Delete", content_resource_path(resource), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-4 py-2 rounded-md bg-red-500 text-white hover:bg-red-700"
          end
        end
      end
    end
  menu label: "Resources"
  index download_links: false, class: "admin-table w-full text-sm text-gray-800 bg-white rounded-xl overflow-hidden shadow" do
    selectable_column
    id_column
    column "Title" do |resource|
      link_to resource.title, content_resource_path(resource), class: "text-primary hover:text-primary-dark font-semibold"
    end
    column "Resource Type" do |resource|
      type_class = case resource.resource_type
      when 'blog' then 'badge-status bg-blue-100 text-blue-800'
      when 'webinar' then 'badge-status bg-green-100 text-green-800'
      when 'event' then 'badge-status bg-purple-100 text-purple-800'
      when 'opportunity' then 'badge-status bg-orange-100 text-orange-800'
      when 'knowledge_hub' then 'badge-status bg-indigo-100 text-indigo-800'
      when 'template' then 'badge-status bg-pink-100 text-pink-800'
      else 'badge-status bg-gray-100 text-gray-800'
      end
      content_tag(:span, resource.resource_type.titleize, class: type_class)
    end
    column "Category", :category
    column "Author", :author
    column "Active" do |resource|
      status = resource.active ? 'Active' : 'Inactive'
      color_class = resource.active ? 'badge-status bg-green-100 text-green-700' : 'badge-status bg-red-100 text-red-700'
      content_tag(:span, status, class: color_class)
    end
    column "Published At" do |resource|
      resource.published_at&.strftime("%b %d, %Y at %I:%M %p")
    end
    actions defaults: false do |resource|
      content_tag :div, class: "flex items-center border-b border-gray-200" do
        safe_join([
          link_to("View", content_resource_path(resource), class: "btn-primary text-xs px-3 py-1 mr-2 rounded-md bg-primary hover:bg-primary-dark text-white"),
          link_to("Delete", content_resource_path(resource), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-3 py-1 rounded-md bg-red-500 text-white hover:bg-red-700")
        ])
      end
    end
  end

  form do |f|
    f.semantic_errors
    div class: "max-w-3xl mx-auto p-8 bg-white rounded-2xl shadow space-y-8 border border-gray-200" do
      f.inputs "Resource Details", class: "space-y-6" do
        div class: "flex flex-col gap-6" do
          div do
            f.label :title, class: "block text-sm font-bold text-primary mb-2 text-left"
            f.input :title, required: true, input_html: { class: "form-input w-full border-gray-300 focus:border-primary focus:ring focus:ring-primary/30 bg-white text-gray-900" }, label: false
          end
          div class: "grid grid-cols-1 md:grid-cols-2 gap-6" do
            div do
              f.label :resource_type, class: "block text-sm font-semibold text-gray-800 mb-2 text-left"
              f.input :resource_type, as: :select, collection: ['blog', 'event', 'webinar', 'opportunity', 'template', 'knowledge_hub'], required: true, input_html: { class: "form-input w-full bg-white text-gray-900" }, label: false
            end
            div do
              f.label :category, class: "block text-sm font-semibold text-gray-800 mb-2 text-left"
              f.input :category, input_html: { class: "form-input w-full bg-white text-gray-900" }, label: false
            end
            div do
              f.label :author, class: "block text-sm font-semibold text-gray-800 mb-2 text-left"
              f.input :author, input_html: { class: "form-input w-full bg-white text-gray-900" }, label: false
            end
            div do
              f.label :url, class: "block text-sm font-semibold text-gray-800 mb-2 text-left"
              f.input :url, input_html: { class: "form-input w-full bg-white text-gray-900" }, label: false
            end
          end
          div class: "border-t border-gray-200 pt-6 mt-4" do
            f.label :description, class: "block text-sm font-semibold text-gray-800 mb-2 text-left"
            f.input :description, as: :trix_editor, input_html: { class: "form-input w-full bg-white text-gray-900" }, label: false
          end
          div do
            f.label :content, class: "block text-sm font-semibold text-gray-800 mb-2 text-left"
            f.input :content, as: :trix_editor, input_html: { class: "form-input h-40 w-full bg-white text-gray-900" }, label: false
          end
          div class: "flex items-center gap-3 pt-4 border-t border-gray-200 mt-4" do
            f.label :active, "Active (toggle)", class: "block text-sm font-semibold text-gray-800 text-left"
            f.input :active, as: :boolean, input_html: { class: "toggle-checkbox h-5 w-5 text-primary border-gray-300 rounded focus:ring-primary/30" }, label: false
          end
        end
      end
      f.actions do
        f.action :submit, button_html: { class: "btn-primary bg-primary hover:bg-primary-dark text-white px-6 py-2 rounded-md" }
        f.cancel_link class: "btn-secondary bg-gray-200 hover:bg-gray-300 text-gray-800 px-6 py-2 rounded-md"
      end
    end
  end
  end
