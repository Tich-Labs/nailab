# frozen_string_literal: true

ActiveAdmin.register PricingPage do
  menu label: "Pricing"
  permit_params :title, :content

  form do |f|
    f.inputs "Pricing Page Content" do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end
end
