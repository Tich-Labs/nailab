
ActiveAdmin.register Program do
  permit_params :title, :summary, :description, :categories, :image, :video_url,
                :meta_title, :meta_description

  index do
    selectable_column
    id_column
    column :title
    column :summary do |p|
      p.summary&.truncate(60) || "—"
    end
    column :categories do |p|
      Array(p.categories).join(", ")
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Program Details" do
      f.input :title
      f.input :summary
      f.input :description, as: :text
      f.input :categories, as: :check_boxes,
              collection: ["Startup Incubation & Acceleration", "Masterclasses & Mentorship",
                           "Funding Access", "Research & Development", "Social Impact Programs"]
      f.input :image, as: :file
      f.input :video_url
      f.input :meta_title
      f.input :meta_description
    end
    f.actions
  end

  filter :categories, as: :check_boxes
end
