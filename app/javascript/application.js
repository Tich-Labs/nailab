// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Application } from "@hotwired/stimulus";
import "@hotwired/turbo-rails";
import "controllers";

const application = Application.start();
application.debug = false; // Disable debug in production
window.Stimulus = application;
