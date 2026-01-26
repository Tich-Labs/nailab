import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form", "flash"]

  connect() {
    // ensure modal hidden
    if (this.hasModalTarget) this.modalTarget.style.display = "none"
  }

  open() {
    if (this.hasModalTarget) this.modalTarget.style.display = "block"
  }

  close() {
    if (this.hasModalTarget) this.modalTarget.style.display = "none"
  }

  async submit(event) {
    event.preventDefault()
    const url = this.formTarget.action
    const formData = new FormData(this.formTarget)

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    if (!token) return this.showFlash('Missing CSRF token on page', 'error')

    try {
      // Ensure the CSRF token is included in the form payload and cookies are sent
      formData.append('authenticity_token', token)
      const res = await fetch(url, {
        method: 'POST',
        headers: { 'X-CSRF-Token': token, 'Accept': 'application/json' },
        body: formData,
        credentials: 'include'
      })

      const json = await res.json()
      if (res.ok && json.success) {
        this.showFlash('Invite sent', 'success')
        setTimeout(() => this.close(), 1000)
      } else {
        this.showFlash((json.errors || json.error || ['Failed to send invite']).join ? (json.errors || json.error).join('; ') : json.error || 'Failed to send invite', 'error')
      }
    } catch (e) {
      this.showFlash('Network error sending invite', 'error')
    }
  }

  showFlash(message, type = 'info') {
    if (!this.hasFlashTarget) return
    this.flashTarget.innerHTML = `<div class="p-2 rounded text-sm ${type === 'success' ? 'text-green-700 bg-green-50' : 'text-red-700 bg-red-50'}">${message}</div>`
  }
}
