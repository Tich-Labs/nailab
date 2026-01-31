import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.currentFilter = this.element.dataset.initialFilter || 'all'
    console.debug('[conversation-list] connect, initialFilter=', this.currentFilter)
    this.updateList()
    // On connect, preserve server-rendered button styles (don't override)
  }

  filter(event) {
    // Let the link navigate naturally - server will re-render with correct @filter
    // No preventDefault needed; just let the browser/Turbo handle navigation
    console.debug('[conversation-list] filter link clicked, letting it navigate')
  }

  updateList() {
    const items = this.element.querySelectorAll('[data-type]')
    items.forEach(i => {
      const type = i.dataset.type
      if (this.currentFilter === 'all' || type === this.currentFilter) {
        i.style.display = ''
      } else {
        i.style.display = 'none'
      }
    })
  }

  updateButtons() {
    const buttons = this.element.querySelectorAll('[data-filter]')

    // First, set all to unselected base state
    buttons.forEach(b => {
      b.classList.remove('bg-purple-600','text-white')
      b.classList.add('btn','btn-sm','bg-white','text-black')
    })

    // Then apply selected styling to the matching button only
    const selected = this.element.querySelector(`[data-filter="${this.currentFilter}"]`)
    if (selected) {
      selected.classList.remove('bg-white','text-black')
      selected.classList.add('bg-purple-600','text-white')
    } else {
      // fallback: if no match, make the 'all' button selected
      const allBtn = this.element.querySelector('[data-filter="all"]')
      if (allBtn) {
        allBtn.classList.remove('bg-white','text-black')
        allBtn.classList.add('bg-purple-600','text-white')
      }
    }
    console.debug('[conversation-list] updateButtons done, currentFilter=', this.currentFilter)
  }

  disconnect() {
    // no cleanup needed now
  }

  // optional: keep selection highlight when clicking an item
  select(event) {
    const anchors = this.element.querySelectorAll('a[data-type]')
    anchors.forEach(a => a.classList.remove('bg-nailab-teal/10', 'border-l-4', 'border-nailab-teal'))
    const clicked = event.currentTarget
    clicked.classList.add('bg-nailab-teal/10', 'border-l-4', 'border-nailab-teal')
  }
}
