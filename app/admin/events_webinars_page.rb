# frozen_string_literal: true

ActiveAdmin.register EventsWebinarsPage do
  menu label: "Resources: Events & Webinars"
  permit_params :title, :content

  form do |f|
    f.inputs "Events & Webinars Page Content" do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end
end
