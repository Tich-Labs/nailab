// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Application } from "@hotwired/stimulus";

const application = Application.start();
application.debug = true; // Enable debug mode for development
window.Stimulus = application;

// Import Turbo and controllers
import "@hotwired/turbo-rails";
import "controllers";
