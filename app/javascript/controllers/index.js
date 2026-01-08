import { application } from "./application"

// Manually import and register public controllers only
import DropdownController from "./dropdown_controller"
import FaqController from "./faq_controller"
import MobileMenuController from "./mobile_menu_controller"
import TestimonialSliderController from "./testimonial_slider_controller"

application.register("dropdown", DropdownController)
application.register("faq", FaqController)
application.register("mobile-menu", MobileMenuController)
application.register("testimonial-slider", TestimonialSliderController)
