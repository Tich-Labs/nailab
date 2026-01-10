import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown"]

  connect() {
    this.open = false
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
  }

  toggleDropdown() {
    this.open = !this.open
    if (this.open) {
      this.dropdownTarget.classList.remove('hidden')
      this.fetchNotifications()
      // mark all as read on open
      this.markAllRead()
      window.addEventListener('click', this.handleOutsideClick)
    } else {
      this.closeDropdown()
    }
  }

  closeDropdown() {
    this.open = false
    this.dropdownTarget.classList.add('hidden')
    window.removeEventListener('click', this.handleOutsideClick)
  }

  handleOutsideClick(e) {
    if (!this.element.contains(e.target)) { this.closeDropdown() }
  }

  fetchNotifications() {
    fetch('/notifications')
      .then(res => res.text())
      .then(html => {
        const parser = new DOMParser()
        const doc = parser.parseFromString(html, 'text/html')
        const preview = doc.querySelector('#notifications-preview')
        const list = this.dropdownTarget.querySelector('#notifications-list')
        if (preview && list) { list.innerHTML = preview.innerHTML }
      })
      .catch(err => console.error('Failed to fetch notifications', err))
  }

  markAllRead() {
    fetch('/notifications/mark_all_read', {
      method: 'POST',
      headers: { 'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content, 'Accept': 'application/json' }
    })
      .then(res => res.json())
      .then(json => {
        const countEl = document.getElementById('notifications-count')
        if (countEl) { countEl.textContent = json.unread_count }
      })
      .catch(err => console.error('markAllRead failed', err))
  }

  handleNotificationClick(e) {
    const item = e.currentTarget
    const id = item.dataset.notificationId
    const link = item.dataset.notificationLink
    if (!id) return

    fetch(`/notifications/${id}/mark_read`, {
      method: 'POST',
      headers: { 'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content, 'Accept': 'application/json' }
    })
      .then(res => res.json())
      .then(json => {
        // update badge
        const countEl = document.getElementById('notifications-count')
        if (countEl) {
          // decrement or set to zero
          const current = parseInt(countEl.textContent || '0', 10)
          countEl.textContent = Math.max(0, current - 1)
        }
        if (json.redirect) {
          window.location = json.redirect
        } else if (link) {
          window.location = link
        } else {
          // remove or style as read
          item.classList.remove('bg-gray-50')
        }
      })
      .catch(err => console.error('mark_read failed', err))
  }
}
import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable/src"

export default class extends Controller {
  connect() {
    try {
      if (!window.currentUserId) return
      this.consumer = createConsumer()
      this.subscription = this.consumer.subscriptions.create(
        { channel: "NotificationsChannel" },
        {
          received: (data) => this.receive(data)
        }
      )
    } catch (e) {
      // silent
    }
  }

  disconnect() {
    if (this.subscription) this.subscription.unsubscribe()
    if (this.consumer && this.consumer.disconnect) this.consumer.disconnect()
  }

  receive(data) {
    const badge = document.getElementById('notifications-badge')
    const count = document.getElementById('notifications-count')
    const live = document.getElementById('notifications-live')
    if (count) {
      const newCount = (data.unread_count || 0)
      count.textContent = newCount
      if (badge) badge.style.display = ''
      if (live) live.textContent = `You have ${newCount} unread notifications`
    }
  }
}
