# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"

pin "swiper" # @12.0.3
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.20
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @8.1.100
pin "@hotwired/stimulus", to: "stimulus.min.js"

# Pin public controllers only (admin controllers handled separately)
pin_all_from "app/javascript/controllers", under: "controllers"
# Admin JavaScript file with admin controllers
pin "admin", to: "admin.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
