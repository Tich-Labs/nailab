# frozen_string_literal: true

ActiveAdmin.register ProgramsPage do
  menu label: "Programs"
  permit_params :title, :content

  form do |f|
    f.inputs "Programs Page Content" do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end
end
