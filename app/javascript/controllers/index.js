import { application } from "./application"
import NotificationsController from "./notifications_controller"
import AjaxFlashController from "./ajax_flash_controller"
import ProgramFilterController from "./program_filter_controller"
import PasswordVisibilityController from "./password_visibility_controller"
import InviteModalController from "./invite_modal_controller"
import ModalController from "./modal_controller"
import MobileMenuController from "./mobile_menu_controller"
import BookmarkButtonController from "./bookmark_button_controller"
import RequireSignupController from "./require_signup_controller"
import DashboardController from "./dashboard_controller"
import ConversationListController from "./conversation_list_controller"

application.register("notifications", NotificationsController)
application.register("ajax-flash", AjaxFlashController)
application.register("program-filter", ProgramFilterController)
application.register("password-visibility", PasswordVisibilityController)
application.register("invite-modal", InviteModalController)
application.register("modal", ModalController)
application.register("mobile-menu", MobileMenuController)
application.register("bookmark-button", BookmarkButtonController)
application.register("dashboard", DashboardController)
application.register("require-signup", RequireSignupController)
application.register("conversation-list", ConversationListController)

// All controllers are auto-registered via pin_all_from
// No manual registration needed