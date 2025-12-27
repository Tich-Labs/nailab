# app/admin/content/resources.rb
ActiveAdmin.register Resource, namespace: :content do
  menu label: "Resources"
  index do
    selectable_column
    column "Title" do |resource|
      link_to resource.title, content_resource_path(resource), class: "text-primary hover:text-primary-dark"
    end
    column "Resource Type" do |resource|
      type_class = case resource.resource_type
      when 'blog' then 'bg-blue-100 text-blue-800'
      when 'webinar' then 'bg-green-100 text-green-800'
      when 'event' then 'bg-purple-100 text-purple-800'
      when 'opportunity' then 'bg-orange-100 text-orange-800'
      when 'knowledge_hub' then 'bg-indigo-100 text-indigo-800'
      when 'template' then 'bg-pink-100 text-pink-800'
      else 'bg-gray-100 text-gray-800'
      end
      content_tag(:span, resource.resource_type.titleize, class: "px-2 py-1 rounded #{type_class}")
    end
    column "Category", :category
    column "Author", :author
    column "Active" do |resource|
      status_tag(resource.active ? 'Active' : 'Inactive', class: resource.active ? 'status-ok' : 'status-error')
    end
    column "Published At", :published_at
    actions
  end

  form do |f|
    f.semantic_errors
    div class: "max-w-3xl mx-auto p-6 bg-white rounded-lg shadow space-y-6" do
      f.inputs "Resource Details" do
        f.input :title, required: true, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :resource_type, as: :select, collection: ['blog', 'event', 'webinar', 'opportunity', 'template', 'knowledge_hub'], required: true, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :category, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :author, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :description, as: :trix_editor, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :content, as: :trix_editor, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :url, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :published_at, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :active, input_html: { class: "h-4 w-4 text-primary border-gray-300 rounded focus:ring-primary/30" }
      end
      f.actions
    end
  end
  end
