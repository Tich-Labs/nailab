# frozen_string_literal: true

ActiveAdmin.register ContactPage do
  menu label: "Contact Us"
  permit_params :title, :content

  form do |f|
    f.inputs "Contact Page Content" do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end
end
