import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container" ]

  connect() {
    // no-op
  }

  show(message, type = "success") {
    const el = document.createElement("div")
    el.className = `px-4 py-2 rounded shadow ${type === 'error' ? 'bg-red-600 text-white' : 'bg-green-600 text-white'}`
    el.textContent = message
    this.element.appendChild(el)
    setTimeout(() => el.remove(), 4000)
  }
}
