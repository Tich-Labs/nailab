// app/javascript/controllers/faq_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["answer", "button"]

  toggle(event) {
    const idx = event.currentTarget.dataset.faqIndex
    this.answerTargets.forEach((el, i) => {
      if (i == idx) {
        el.classList.toggle("hidden")
        this.buttonTargets[i].querySelector('svg').classList.toggle('rotate-180')
      } else {
        el.classList.add("hidden")
        this.buttonTargets[i].querySelector('svg').classList.remove('rotate-180')
      }
    })
  }
}
