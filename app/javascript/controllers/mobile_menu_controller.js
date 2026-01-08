import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "icon", "topLine", "middleLine", "bottomLine"]

  connect() {
    this.open = false;
    this.handleClickOutside = this.handleClickOutside.bind(this);
    document.addEventListener('click', this.handleClickOutside);
    
    // Close dropdowns when mobile menu opens
    this.closeDropdownsHandler = this.closeDropdowns.bind(this);
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside);
  }

  toggle(event) {
    event.stopPropagation();
    
    // Close all dropdowns when opening mobile menu
    if (!this.open) {
      document.querySelectorAll("[data-controller='dropdown']").forEach((dropdown) => {
        const menu = dropdown.querySelector("[data-dropdown-target='menu']")
        if (menu) menu.classList.add("hidden")
      })
    }
    
    this.open = !this.open;
    this.menuTarget.classList.toggle('hidden', !this.open);
    this.updateIcon();
  }

  updateIcon() {
    if (this.hasIconTarget) {
      const icon = this.iconTarget;
      const paths = icon.querySelectorAll('path');

      if (this.open) {
        // Animate to X
        if (paths.length >= 3) {
          paths[0].setAttribute('d', 'M6 6L18 18'); // Top line to \
          paths[1].style.opacity = '0'; // Middle line disappears
          paths[2].setAttribute('d', 'M6 18L18 6'); // Bottom line to /
        }
      } else {
        // Animate back to hamburger
        if (paths.length >= 3) {
          paths[0].setAttribute('d', 'M4 6h16'); // Top line back
          paths[1].style.opacity = '1'; // Middle line reappears
          paths[2].setAttribute('d', 'M4 18h16'); // Bottom line back
        }
      }
    }
  }

  handleClickOutside(event) {
    if (this.open && !this.element.contains(event.target)) {
      this.open = false;
      this.menuTarget.classList.add('hidden');
      this.updateIcon();
    }
  }

  close() {
    if (this.open) {
      this.open = false;
      this.menuTarget.classList.add('hidden');
      this.updateIcon();
    }
  }
  
  closeDropdowns() {
    document.querySelectorAll("[data-controller='dropdown']").forEach((dropdown) => {
      const menu = dropdown.querySelector("[data-dropdown-target='menu']")
      if (menu) menu.classList.add("hidden")
    })
  }
}
