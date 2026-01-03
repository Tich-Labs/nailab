# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "stimulus-loading", to: "https://ga.jspm.io/npm:@hotwired/stimulus-loading@1.0.1/dist/stimulus-loading.js"
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.20
pin "swiper" # @12.0.3
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.20
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @8.1.100

pin_all_from "app/javascript/controllers", under: "controllers"
