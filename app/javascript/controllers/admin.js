import { application } from "./application"

// Admin-only controllers
import AdminFocusAreasController from "./admin_focus_areas_controller"
import AdminSidebarController from "./admin_sidebar_controller"

// Register admin controllers
application.register("admin-focus-areas", AdminFocusAreasController)
application.register("admin-sidebar", AdminSidebarController)