# frozen_string_literal: true

ActiveAdmin.register Footer do
  menu parent: "Content", priority: 3
  permit_params :content
end
