// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Application } from "@hotwired/stimulus";
import "controllers";

const application = Application.start();
application.debug = false; // Disable debug in production
window.Stimulus = application;

// Import Turbo and controllers
import "@hotwired/turbo-rails";
import "controllers";
application.debug = true; // Enable debug mode for development
window.Stimulus = application;

// Import Turbo and controllers
import "@hotwired/turbo-rails";
import "controllers";
