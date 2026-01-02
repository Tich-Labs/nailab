# frozen_string_literal: true

ActiveAdmin.register OpportunitiesPage do
  menu label: "Resources: Opportunities"
  permit_params :title, :content

  form do |f|
    f.inputs "Opportunities Page Content" do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end
end
