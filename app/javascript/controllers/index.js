import { application } from "./application"
import NotificationsController from "./notifications_controller"
import AjaxFlashController from "./ajax_flash_controller"
import ProgramFilterController from "./program_filter_controller"
import PasswordVisibilityController from "./password_visibility_controller"

application.register("notifications", NotificationsController)
application.register("ajax-flash", AjaxFlashController)
application.register("program-filter", ProgramFilterController)
application.register("password-visibility", PasswordVisibilityController)

// All controllers are auto-registered via pin_all_from
// No manual registration needed