// app/javascript/controllers/faq_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "answer"]

    connect() {
      console.log("FAQ controller connected");
    }

  toggle(event) {
    const idx = this.buttonTargets.indexOf(event.currentTarget);
    if (idx === -1) return;
    this.answerTargets[idx].classList.toggle('hidden');
    const chevron = this.buttonTargets[idx].querySelector('svg');
    if (chevron) {
      chevron.classList.toggle('rotate-180');
    }
  }
}