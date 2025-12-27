# app/admin/content/programs.rb
ActiveAdmin.register Program, namespace: :content do
  menu label: "Programs"

  permit_params :title, :description, :content, :category, :video_url,
                :slug, :active, :start_date, :end_date, :image

  index download_links: false, class: "admin-table w-full text-sm text-gray-800 bg-white rounded-xl overflow-hidden shadow" do
    selectable_column
    id_column
    column :title
    column :category
    column :content do |p|
      p.content&.truncate(60) || "—"
    end
    column :video_url
    column :image do |p|
      if p.image.attached?
        image_tag url_for(p.image), width: 60
      else
        "—"
      end
    end
    column :active
    column "Created At" do |p|
      p.created_at&.strftime("%b %d, %Y at %I:%M %p")
    end
    actions defaults: false do |p|
      content_tag :div, class: "flex items-center gap-2" do
        safe_join([
          link_to("View", content_program_path(p), class: "btn-primary text-xs px-3 py-1 rounded-md bg-primary hover:bg-primary-dark text-white"),
          link_to("Delete", content_program_path(p), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-3 py-1 rounded-md bg-red-500 text-white hover:bg-red-700")
        ])
      end
    end
  end

  show title: proc { |p| p.title } do
    div class: "max-w-3xl mx-auto bg-white rounded-xl shadow p-8 space-y-6" do
      attributes_table_for resource do
        row :id
        row :title
        row :description
        row :content
        row :category
        row :video_url
        row :slug
        row :active
        row :start_date
        row :end_date
        row :created_at
        row :updated_at
      end
      div class: "flex gap-4 mt-8" do
        span do
          link_to "Edit", edit_content_program_path(resource), class: "btn-primary text-xs px-4 py-2 rounded-md bg-primary hover:bg-primary-dark text-white"
        end
        span do
          link_to "Delete", content_program_path(resource), method: :delete, data: { confirm: "Are you sure?" }, class: "btn-secondary text-xs px-4 py-2 rounded-md bg-red-500 text-white hover:bg-red-700"
        end
      end
    end
  end

  form do |f|
    div class: "max-w-3xl mx-auto p-6 bg-white rounded-lg shadow space-y-6" do
      f.inputs "Program Details" do
        f.input :title, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :slug, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :description, as: :trix_editor, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :content, as: :trix_editor, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :category, as: :select, collection: ["Startup Incubation & Acceleration", "Masterclasses & Mentorship",
                             "Funding Access", "Research & Development", "Social Impact Programs"], include_blank: false,
                             input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :video_url, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(url_for(f.object.image), width: 100, class: "rounded shadow") : content_tag(:span, "No image uploaded"), input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :active, input_html: { class: "h-4 w-4 text-primary border-gray-300 rounded focus:ring-primary/30" }
        f.input :start_date, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
        f.input :end_date, input_html: { class: "block w-full rounded border-gray-300 focus:border-primary focus:ring focus:ring-primary/30" }
      end
      f.actions
    end
  end

  filter :category, as: :select, collection: ["Startup Incubation & Acceleration", "Masterclasses & Mentorship",
                           "Funding Access", "Research & Development", "Social Impact Programs"]
end
