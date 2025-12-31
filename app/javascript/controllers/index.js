// app/javascript/controllers/index.js
import { application } from "./application"

import FaqController from "./faq_controller"
import DropdownController from "./dropdown_controller"
import MobileMenuController from "./mobile_menu_controller"
import TestimonialSliderController from "./testimonial_slider_controller"

application.register("faq", FaqController)
application.register("dropdown", DropdownController)
application.register("mobile-menu", MobileMenuController)
application.register("testimonial-slider", TestimonialSliderController)
