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

# Configure custom manifest filename for production
config.manifest_path = Rails.root.join("public/assets/manifest-#{Rails.env.short_version}-#{Digest::SHA256.hex(File.read(Rails.root.join("app/assets/config/manifest.js"))}.json")
