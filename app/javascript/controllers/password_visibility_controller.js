import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field", "toggle"]

  connect() {
    this.visible = false
    // ensure the initial icon matches state
    this._updateToggle()
  }

  toggle(event) {
    event.preventDefault()
    this.visible = !this.visible
    this.fieldTargets.forEach((f) => {
      try {
        // Prefer setAttribute which is safer across browsers.
        f.setAttribute('type', this.visible ? 'text' : 'password')
        f.type = this.visible ? 'text' : 'password'
      } catch (e) {
        // If still failing, ignore — visibility toggle may not work in this browser.
        console.warn('password-visibility: could not change input type', e)
      }
    })
    this._updateToggle()
  }

  _updateToggle() {
    if (!this.hasToggleTarget) return
    const svgEye = '<svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M12 15a3 3 0 100-6 3 3 0 000 6z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path></svg>'
    const svgEyeOff = '<svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M3 3l18 18" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M10.477 10.477A3 3 0 0113.523 13.523" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M9.88 5.26C11.06 5.09 12.27 5 13.5 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-1.58 0-3.09-.27-4.47-.76" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path></svg>'
    this.toggleTarget.innerHTML = this.visible ? svgEyeOff : svgEye
    this.toggleTarget.setAttribute('aria-pressed', this.visible.toString())
  }
}
