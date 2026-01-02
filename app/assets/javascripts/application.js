
import { Application } from "@hotwired/stimulus"
import DropdownController from "./controllers/dropdown_controller"
import AdminFocusAreasController from "./controllers/admin_focus_areas_controller"
const application = Application.start()
application.register("dropdown", DropdownController)
application.register("admin-focus-areas", AdminFocusAreasController)
