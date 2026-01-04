import { application } from "./application"

// Manually import and register controllers
import DropdownController from "./dropdown_controller"
import FaqController from "./faq_controller"
import MobileMenuController from "./mobile_menu_controller"
import TestimonialSliderController from "./testimonial_slider_controller"
import AdminFocusAreasController from "./admin_focus_areas_controller"
import AdminSidebarController from "./admin_sidebar_controller"

application.register("dropdown", DropdownController)
application.register("faq", FaqController)
application.register("mobile-menu", MobileMenuController)
application.register("testimonial-slider", TestimonialSliderController)
application.register("admin-focus-areas", AdminFocusAreasController)
application.register("admin-sidebar", AdminSidebarController)
