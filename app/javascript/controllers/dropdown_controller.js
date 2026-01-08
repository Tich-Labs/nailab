import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    // Close mobile menu if open (avoid conflicts)
    const mobileMenu = document.querySelector('[data-controller="mobile-menu"]')
    if (mobileMenu) {
      const mobileMenuController = this.application.getControllerForElementAndIdentifier(mobileMenu, 'mobile-menu')
      if (mobileMenuController && mobileMenuController.close) {
        mobileMenuController.close()
      }
    }

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
      
      // Add escape key listener
      document.addEventListener("keydown", this.escapeHandler)
    } else {
      document.removeEventListener("click", this.hideHandler)
      document.removeEventListener("keydown", this.escapeHandler)
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

  closeAllDropdowns() {
    document.querySelectorAll("[data-controller='dropdown']").forEach((dropdown) => {
      const menu = dropdown.querySelector("[data-dropdown-target='menu']")
      if (menu) menu.classList.add("hidden")
    })
  }

  connect() {
    this.hideHandler = this.hide.bind(this)
    this.escapeHandler = this.escape.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.hideHandler)
    document.removeEventListener("keydown", this.escapeHandler)
  }

  escape(event) {
    if (event.key === 'Escape' && !this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.add("hidden")
      document.removeEventListener("click", this.hideHandler)
      document.removeEventListener("keydown", this.escapeHandler)
    }
  }
}
