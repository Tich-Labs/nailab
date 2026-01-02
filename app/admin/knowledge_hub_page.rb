# frozen_string_literal: true

ActiveAdmin.register KnowledgeHubPage do
  menu label: "Resources: Knowledge Hub"
  permit_params :title, :content

  form do |f|
    f.inputs "Knowledge Hub Page Content" do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end
end
