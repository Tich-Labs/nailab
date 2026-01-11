import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["dropdown"]

  connect() {
    this.open = false
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    this._itemClickHandler = this.handleNotificationClick.bind(this)
    if (this.hasDropdownTarget) this.dropdownTarget.classList.add('hidden')
    this.setupActionCable()
  }

  disconnect() {
    this.closeDropdown()
    if (this.subscription) {
      try { this.subscription.unsubscribe() } catch (e) {}
      this.subscription = null
    }
    if (this.consumer && this.consumer.disconnect) {
      try { this.consumer.disconnect() } catch (e) {}
    }
  }

  setupActionCable() {
    try {
      if (!window.currentUserId) return
      this.consumer = createConsumer()
      this.subscription = this.consumer.subscriptions.create(
        { channel: "NotificationsChannel" },
        { received: (data) => this.receive(data) }
      )
    } catch (e) {
      // Fail silently; real-time updates are best-effort
      console.error('NotificationsChannel subscribe error', e)
    }
  }

  toggleDropdown() {
    this.open = !this.open
    if (this.open && this.hasDropdownTarget) {
      this.dropdownTarget.classList.remove('hidden')
      this.fetchNotifications()
      this.markAllRead()
      window.addEventListener('click', this.handleOutsideClick)
    } else {
      this.closeDropdown()
    }
  }

  closeDropdown() {
    this.open = false
    if (this.hasDropdownTarget) this.dropdownTarget.classList.add('hidden')
    window.removeEventListener('click', this.handleOutsideClick)
  }

  handleOutsideClick(e) {
    if (!this.element.contains(e.target)) { this.closeDropdown() }
  }

  fetchNotifications() {
    fetch('/notifications', { headers: { 'Accept': 'text/html' } })
      .then(res => res.text())
      .then(html => {
        const parser = new DOMParser()
        const doc = parser.parseFromString(html, 'text/html')
        const preview = doc.querySelector('#notifications-preview')
        const list = (this.hasDropdownTarget && this.dropdownTarget.querySelector('#notifications-list')) || document.querySelector('#notifications-list')
        if (preview && list) {
          list.innerHTML = preview.innerHTML
        } else if (list) {
          list.innerHTML = html
        }
        this.attachItemHandlers()
      })
      .catch(err => console.error('Failed to fetch notifications', err))
  }

  attachItemHandlers() {
    const container = (this.hasDropdownTarget && this.dropdownTarget) || document
    const items = container.querySelectorAll('[data-notification-id]')
    items.forEach(i => {
      i.removeEventListener('click', this._itemClickHandler)
      i.addEventListener('click', this._itemClickHandler)
    })
  }

  markAllRead() {
    const token = document.querySelector('meta[name="csrf-token"]')?.content
    if (!token) return
    fetch('/notifications/mark_all_read', {
      method: 'POST',
      headers: { 'X-CSRF-Token': token, 'Accept': 'application/json' },
      credentials: 'same-origin'
    })
      .then(res => res.json())
      .then(json => {
        const countEl = document.getElementById('notifications-count')
        const badge = document.getElementById('notifications-badge')
        if (countEl) countEl.textContent = json.unread_count
        if (badge && Number(json.unread_count) === 0) badge.style.display = 'none'
      })
      .catch(err => console.error('markAllRead failed', err))
  }

  handleNotificationClick(e) {
    // allow both clicks on container and inner elements
    let el = e.currentTarget
    const id = el.dataset.notificationId
    const link = el.dataset.notificationLink
    if (!id) return

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    fetch(`/notifications/${id}/mark_read`, {
      method: 'POST',
      headers: { 'X-CSRF-Token': token, 'Accept': 'application/json' },
      credentials: 'same-origin'
    })
      .then(res => res.json())
      .then(json => {
        const countEl = document.getElementById('notifications-count')
        if (countEl) {
          const current = parseInt(countEl.textContent || '0', 10)
          countEl.textContent = Math.max(0, current - 1)
        }
        if (json.redirect) {
          window.location = json.redirect
        } else if (link) {
          window.location = link
        } else {
          el.classList.remove('bg-gray-50')
        }
      })
      .catch(err => console.error('mark_read failed', err))
  }

  receive(data) {
    try {
      const badge = document.getElementById('notifications-badge')
      const count = document.getElementById('notifications-count')
      const live = document.getElementById('notifications-live')
      if (count) {
        const newCount = (data.unread_count || 0)
        count.textContent = newCount
        if (badge) badge.style.display = ''
        if (live) live.textContent = `You have ${newCount} unread notifications`
      }

      // Optionally prepend a simple preview item to the list to make new notification visible
      const list = (this.hasDropdownTarget && this.dropdownTarget.querySelector('#notifications-list')) || document.querySelector('#notifications-list')
      if (list && data.id && data.title) {
        const item = document.createElement('div')
        item.dataset.notificationId = data.id
        if (data.link) item.dataset.notificationLink = data.link
        item.className = 'p-3 border-b border-gray-100 notification-item cursor-pointer'
        item.innerHTML = `<div class="text-sm font-medium text-gray-900">${escapeHtml(data.title)}</div><div class="text-sm text-gray-600">${escapeHtml(data.message || '')}</div>`
        list.prepend(item)
        // attach click handler
        item.addEventListener('click', this._itemClickHandler)
      }
    } catch (e) {
      // silent
    }
  }
}

// Small helper to avoid injecting raw HTML from broadcasts
function escapeHtml(unsafe) {
  return String(unsafe)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;")
    .replace(/'/g, "&#039;")
}
