// app/javascript/controllers/index.js
import { application } from "./application"
import FaqController from "./faq_controller"
import DropdownController from "./dropdown_controller"

application.register("faq", FaqController)
application.register("dropdown", DropdownController)
