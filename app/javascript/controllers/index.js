import { application } from "./application"
import { eagerLoadControllersFrom } from "stimulus-loading"

// Eager load all controllers
eagerLoadControllersFrom("controllers", application)
