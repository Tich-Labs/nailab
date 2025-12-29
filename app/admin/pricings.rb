# frozen_string_literal: true

ActiveAdmin.register Pricing do
  menu parent: "Content", priority: 6
  permit_params :title, :description
end
