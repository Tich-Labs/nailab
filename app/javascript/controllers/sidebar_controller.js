import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  connect() {
    this.open = false
  }

  toggle() {
    this.open = !this.open
    this.update()
  }

  close() {
    this.open = false
    this.update()
  }

  update() {
    if (this.open) {
      this.element.classList.remove("-translate-x-full")
      document.body.classList.add("overflow-hidden")
    } else {
      this.element.classList.add("-translate-x-full")
      document.body.classList.remove("overflow-hidden")
    }
  }
}
