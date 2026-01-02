# frozen_string_literal: true

ActiveAdmin.register BlogPage do
  menu label: "Resources: Blog"
  permit_params :title, :content

  form do |f|
    f.inputs "Blog Page Content" do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end
end
