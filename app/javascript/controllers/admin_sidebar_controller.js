import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["group"]

  toggle(event) {
    const button = event.currentTarget
    const group = button.nextElementSibling
    const expanded = button.getAttribute("aria-expanded") === "true"

    // Optional: close other groups for a SaaS feel
    this.groupTargets.forEach((el) => {
      if (el !== group) el.classList.add("hidden")
    })
    this.element.querySelectorAll("[aria-expanded='true']").forEach((b) => {
      if (b !== button) b.setAttribute("aria-expanded", "false")
    })

    button.setAttribute("aria-expanded", String(!expanded))
    group.classList.toggle("hidden", expanded)
  }
}
