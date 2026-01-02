# frozen_string_literal: true

ActiveAdmin.register Homepage do
  menu label: "Homepage"
  permit_params :title, :content

  form do |f|
    f.inputs "Homepage Content" do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end
end
