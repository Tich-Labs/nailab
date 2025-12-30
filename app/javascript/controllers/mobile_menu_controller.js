import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.open = false;
    document.addEventListener('click', this.handleClickOutside);
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside);
  }

  toggle = (event) => {
    event.stopPropagation();
    this.open = !this.open;
    this.menuTarget.classList.toggle('hidden', !this.open);
  }

  handleClickOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.open = false;
      this.menuTarget.classList.add('hidden');
    }
  }
}
