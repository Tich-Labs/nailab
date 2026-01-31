import { Controller } from "@hotwired/stimulus";

// Usage: data-controller="require-signup"
//        data-require-signup-signed-in-value="true|false"
export default class extends Controller {
  static values = { signedIn: Boolean };

  maybeBlock(event) {
    if (this.signedInValue) return;
    event.preventDefault();
    // Prompt unauthenticated users to create a paid account
    alert("Please sign in or create a paid account to access this content.");
  }
}
