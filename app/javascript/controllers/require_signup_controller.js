import { Controller } from "@hotwired/stimulus";

// Usage: data-controller="require-signup"
//        data-require-signup-signed-in-value="true|false"
export default class extends Controller {
  static values = { signedIn: Boolean };

  maybeBlock(event) {
    if (this.signedInValue) return;
    event.preventDefault();
    this.showSignupModal();
  }

  showSignupModal() {
    // show a fixed alert bar (avoid duplicate)
    if (document.getElementById('nailab-signup-alert')) return;
    const alertEl = document.createElement('div');
    alertEl.id = 'nailab-signup-alert';
    alertEl.className = 'alert alert-warning fixed left-1/2 top-16 z-50 shadow-lg flex items-center gap-3 animate-fade-in w-full max-w-md rounded-2xl border border-warning/30';
    alertEl.style.width = '380px';
    alertEl.style.transform = 'translateX(-50%)';
    alertEl.innerHTML = `
      <svg class="w-6 h-6 text-warning" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M12 20a8 8 0 100-16 8 8 0 000 16z"></path></svg>
      <span class="font-semibold">This is premium content. Please create a paid account to access.</span>
      <a href="/users/sign_up" class="ml-4 btn btn-sm bg-nailab-purple text-white">Sign Up</a>
      <button id="nailab-signup-alert-close" class="ml-2 btn btn-sm btn-ghost">Close</button>
    `;
    document.body.appendChild(alertEl);
    // close handler and auto-dismiss
    document.getElementById('nailab-signup-alert-close').addEventListener('click', () => alertEl.remove());
    setTimeout(() => { if (alertEl.parentNode) alertEl.remove(); }, 8000);
  }
}
