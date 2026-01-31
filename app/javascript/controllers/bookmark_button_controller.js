import { Controller } from "@hotwired/stimulus";

// Usage: data-controller="bookmark-button"
// data-bookmarked-value="true|false"
// data-resource-id-value="123"
export default class extends Controller {
  static values = { bookmarked: Boolean, resourceId: Number, signedIn: Boolean };
  static targets = ["button"];

  connect() {
    this.updateButton();
  }

  updateButton() {
    if (this.bookmarkedValue) {
      this.buttonTarget.textContent = "Bookmarked";
      this.buttonTarget.classList.remove("bg-nailab-purple");
      this.buttonTarget.classList.add("bg-gray-400", "cursor-default");
      this.buttonTarget.disabled = true;
    } else {
      this.buttonTarget.textContent = "BOOKMARK";
      this.buttonTarget.classList.remove("bg-gray-400", "cursor-default");
      this.buttonTarget.classList.add("bg-nailab-purple");
      this.buttonTarget.disabled = false;
    }
  }

  bookmark(event) {
    event.preventDefault();
    if (this.bookmarkedValue) return;
    if (!this.signedInValue) {
      // Prompt unauthenticated users to create a paid account.
      alert("Please sign in or create a paid account to access this content.");
      return;
    }
    const url = `/founder/resources/${this.resourceIdValue}/bookmark`;
    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "application/json"
      },
      credentials: "same-origin"
    })
      .then((response) => {
        if (response.ok) {
          this.bookmarkedValue = true;
          this.updateButton();
        }
      });
  }
}
