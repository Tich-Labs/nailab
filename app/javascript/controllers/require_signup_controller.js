import { Controller } from "@hotwired/stimulus";

// Usage: data-controller="require-signup"
//        data-require-signup-signed-in-value="true|false"
export default class extends Controller {
  static values = { signedIn: Boolean };

  maybeBlock(event) {
    if (this.signedInValue) return;
    event.preventDefault();
    // Prompt unauthenticated users to sign up; redirect to registration if they confirm.
    if (confirm("Please sign up to access this content. Create an account now?")) {
      window.location.href = '/users/sign_up';
    }
  }
}
