import { Controller } from "@hotwired/stimulus"

// Simple modal controller: traps focus and handles Escape to close.
export default class extends Controller {
  static values = { returnTarget: String }

  connect() {
    this.previousActive = document.activeElement
    this.trapFocus()
    this.handleKey = this.handleKey.bind(this)
    document.addEventListener('keydown', this.handleKey)
  }

  disconnect() {
    document.removeEventListener('keydown', this.handleKey)
    this.releaseFocus()
    if (this.previousActive && typeof this.previousActive.focus === 'function') {
      this.previousActive.focus()
    }
  }

  handleKey(e) {
    if (e.key === 'Escape') {
      e.preventDefault()
      this.close()
    }
    if (e.key === 'Tab') {
      this.maintainTabFocus(e)
    }
  }

  close() {
    // If using Turbo, navigate back to modal route; fallback: hide modal node
    const returnTarget = this.returnTargetValue
    if (returnTarget) {
      window.location.href = returnTarget
    } else {
      this.element.classList.remove('modal-open')
    }
  }

  close(event) {
    event && event.preventDefault()
    this.close()
  }

  trapFocus() {
    this.focusable = this.element.querySelectorAll('a[href], button:not([disabled]), textarea, input, select, [tabindex]:not([tabindex="-1"])')
    if (this.focusable.length) this.focusable[0].focus()
  }

  releaseFocus() {
    // noop for now
  }

  maintainTabFocus(e) {
    if (!this.focusable || this.focusable.length === 0) return
    const first = this.focusable[0]
    const last = this.focusable[this.focusable.length - 1]
    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault(); last.focus()
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault(); first.focus()
    }
  }
}
