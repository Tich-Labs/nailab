import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.form = document.getElementById('focus-area-form')
    if (!this.form) return

    this.idField = document.getElementById('fa-id')
    this.methodField = document.getElementById('fa-method')
    this.titleField = document.getElementById('fa-title')
    this.descriptionField = document.getElementById('fa-description')
    this.iconField = document.getElementById('fa-icon')
    this.activeField = document.getElementById('fa-active')
    this.cancelBtn = document.getElementById('fa-cancel')

    document.querySelectorAll('.focus-edit-btn').forEach(btn => btn.addEventListener('click', (e) => this.populate(e)))
    if (this.cancelBtn) this.cancelBtn.addEventListener('click', () => this.resetForm())

    // New button - reset to create
    document.querySelectorAll('a, button').forEach(el => {
      if (el.id === 'new-focus-btn') el.addEventListener('click', () => this.resetForm())
    })
  }

  populate(e) {
    const btn = e.currentTarget
    const tr = btn.closest('tr')
    const id = tr.dataset.faId
    const title = tr.dataset.faTitle || ''
    const description = tr.dataset.faDescription || ''
    const icon = tr.dataset.faIcon || ''
    const active = tr.dataset.faActive === 'true'

    // set form action to update
    this.form.action = `/admin/focus_area/${id}`
    this.methodField.value = 'patch'
    this.idField.value = id
    this.titleField.value = title
    this.descriptionField.value = description
    this.iconField.value = icon
    this.activeField.checked = active

    // scroll into view
    document.getElementById('editor').scrollIntoView({ behavior: 'smooth' })
    this.titleField.focus()
  }

  resetForm() {
    this.form.action = '/admin/focus_area'
    this.methodField.value = ''
    this.idField.value = ''
    this.titleField.value = ''
    this.descriptionField.value = ''
    this.iconField.value = ''
    this.activeField.checked = true
  }
}
