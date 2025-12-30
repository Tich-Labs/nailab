
import { Application } from "@hotwired/stimulus"
import DropdownController from "./controllers/dropdown_controller"
const application = Application.start()
application.register("dropdown", DropdownController)
