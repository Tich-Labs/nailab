# frozen_string_literal: true

ActiveAdmin.register Faq do
  menu label: "FAQs", priority: 2, parent: "Content Management"
  permit_params :question, :answer, :display_order, :active

  index do
    selectable_column
    id_column
    column :question
    column :display_order
    column :active
    column :updated_at
    actions
  end

  filter :active
  filter :display_order
  filter :question

  form do |f|
    f.inputs "FAQ Details" do
      f.input :question, as: :text
      f.input :answer, as: :text
      f.input :display_order
      f.input :active
    end
    f.actions
  end
end
