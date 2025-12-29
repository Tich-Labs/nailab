ActiveAdmin.register Testimonial do
  menu parent: "HomePage", label: "Testimonials"
  permit_params :quote, :name, :title, :company, :image_url, :company_url, :home_page_id
end
