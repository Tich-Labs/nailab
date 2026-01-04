import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    // Close other dropdowns if any are open
    document.querySelectorAll("[data-controller='dropdown']").forEach((dropdown) => {
      if (dropdown !== this.element) {
        dropdown.querySelector("[data-dropdown-target='menu']")?.classList.add("hidden")
      }
    })

    // Toggle the current dropdown menu
    this.menuTarget.classList.toggle("hidden")

    if (!this.menuTarget.classList.contains("hidden")) {
      // Set a flag to ignore the first document click after opening
      this.ignoreNextDocumentClick = true;
      setTimeout(() => {
        document.addEventListener("click", this.hideHandler)
      }, 0)
    } else {
      document.removeEventListener("click", this.hideHandler)
    }
  }

  hide(event) {
    if (this.ignoreNextDocumentClick) {
      this.ignoreNextDocumentClick = false;
      return;
    }
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      document.removeEventListener("click", this.hideHandler)
    }
  }

  connect() {
    this.hideHandler = this.hide.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.hideHandler)
  }
}
