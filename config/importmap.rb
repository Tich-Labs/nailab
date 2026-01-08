# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"

pin "swiper" # @12.0.3
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.20
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @8.1.100

# Pin public controllers only (admin controllers handled separately)
pin "dropdown_controller", under: "controllers"
pin "faq_controller", under: "controllers"
pin "mobile_menu_controller", under: "controllers"
pin "testimonial_slider_controller", under: "controllers"
# Admin JavaScript file with admin controllers
pin "admin", to: "admin.js"
