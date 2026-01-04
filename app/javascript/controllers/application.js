import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Enable debug mode to see what's happening
application.debug = true
window.Stimulus = application

export { application }
