ActiveAdmin.register ImpactLogo do
  menu parent: "HomePage", label: "Impact Logos"
  permit_params :image_url, :alt_text, :link_url, :home_page_id
end
