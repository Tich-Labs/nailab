# frozen_string_literal: true

ActiveAdmin.register AboutUs do
  # This file was renamed from about_uses.rb to about_us.rb for correct naming
  menu parent: "Content", priority: 2
  permit_params :content
end
