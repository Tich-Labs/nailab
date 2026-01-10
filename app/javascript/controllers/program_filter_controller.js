import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="program-filter"
export default class extends Controller {
  static targets = ["list", "status"]

  connect() {
    this._onPop = this.onPop.bind(this)
    window.addEventListener('popstate', this._onPop)
  }

  disconnect() {
    window.removeEventListener('popstate', this._onPop)
  }

  async filter(event) {
    event.preventDefault()
    const link = event.currentTarget
    const category = link.dataset.category
    const url = link.href

    this._setActive(link)

    try {
      const res = await fetch(url, {
        headers: { "Accept": "text/html" },
        credentials: "same-origin"
      })
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      const html = await res.text()

      // Extract the program list section from the returned HTML
      const parser = new DOMParser()
      const doc = parser.parseFromString(html, 'text/html')
      const newList = doc.querySelector('#programs-list') || doc.querySelector('section')
      if (newList) {
        // Replace inner HTML to preserve the controller element
        this.element.innerHTML = newList.innerHTML
        this._announceCount()
      }
      // update the browser URL without reloading
      window.history.pushState({}, '', url)
    } catch (err) {
      console.error('Program filter error', err)
    }
  }

  onKeydown(event) {
    const key = event.key
    // handle navigation keys for accessibility
    if (key === 'ArrowRight' || key === 'ArrowLeft') {
      event.preventDefault()
      const links = Array.from(this.listTarget.querySelectorAll('a[role="button"]'))
      if (links.length === 0) return
      const current = document.activeElement
      let idx = links.indexOf(current)
      if (idx === -1) {
        // focus first if none focused
        links[0].focus()
        return
      }
      if (key === 'ArrowRight') idx = (idx + 1) % links.length
      else idx = (idx - 1 + links.length) % links.length
      links[idx].focus()
    }

    if (key === 'Enter' || key === ' ') {
      // allow Enter/Space to trigger filtering when focused on a link
      const target = event.target
      if (target && target.matches && target.matches('a[role="button"]')) {
        event.preventDefault()
        this.filter({ currentTarget: target, preventDefault: () => {} })
      }
    }
  }

  async onPop(event) {
    try {
      const res = await fetch(window.location.href, { headers: { "Accept": "text/html" }, credentials: "same-origin" })
      const html = await res.text()
      const parser = new DOMParser()
      const doc = parser.parseFromString(html, 'text/html')
      const newList = doc.querySelector('#programs-list')
      if (newList) {
        this.element.innerHTML = newList.innerHTML
        this._announceCount()
      }
    } catch (err) {
      console.error('Program filter popstate error', err)
    }
  }

  _setActive(link) {
    const container = link.closest('[data-program-filter-target="list"]') || document
    const links = container.querySelectorAll('a[role="button"]')
    links.forEach(a => {
      a.classList.remove('bg-nailab-teal', 'text-white', 'shadow-lg')
      a.setAttribute('aria-pressed', 'false')
    })
    link.classList.add('bg-nailab-teal', 'text-white', 'shadow-lg')
    link.setAttribute('aria-pressed', 'true')
  }

  _announceCount() {
    try {
      const count = this.element.querySelectorAll('.program-card').length
      if (this.hasStatusTarget) {
        this.statusTarget.textContent = `${count} program${count === 1 ? '' : 's'} found.`
      }
    } catch (e) {
      // noop
    }
  }
}
