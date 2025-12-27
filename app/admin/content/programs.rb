# app/admin/content/programs.rb
ActiveAdmin.register Program, namespace: :content do
  menu label: "Programs"

  permit_params :title, :description, :content, :category, :video_url,
                :slug, :active, :start_date, :end_date, :image

  index do
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
    column :created_at
    actions
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
