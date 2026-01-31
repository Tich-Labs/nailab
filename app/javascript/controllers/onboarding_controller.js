import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    this.tabs = Array.from(document.querySelectorAll('.onboarding-tab'))
    this.steps = Array.from(document.querySelectorAll('.onboarding-step'))
    this.tabs.forEach((tab, idx) => {
      tab.addEventListener('click', () => this.showStep(idx))
    })
    this.steps.forEach((step, idx) => {
      const next = step.querySelector('.onboarding-next')
      const prev = step.querySelector('.onboarding-prev')
      if (next) next.addEventListener('click', () => this.showStep(idx + 1))
      if (prev) prev.addEventListener('click', () => this.showStep(idx - 1))
    })
    this.recalcAll()
  }

  showStep(idx) {
    this.steps.forEach((step, i) => {
      step.classList.toggle('hidden', i !== idx)
    })
    this.tabs.forEach((tab, i) => {
      tab.classList.toggle('tab-active', i === idx)
    })
  }

  recalc(event) {
    this.recalcAll()
  }

  recalcAll() {
    this.steps.forEach((step, idx) => {
      const newCustomers = parseInt(step.querySelector(`[name='monthly_metrics[${idx}][new_paying_customers]']`)?.value || 0)
      const churned = parseInt(step.querySelector(`[name='monthly_metrics[${idx}][churned_customers]']`)?.value || 0)
      const cash = parseFloat(step.querySelector(`[name='monthly_metrics[${idx}][cash_at_hand]']`)?.value || 0)
      const mrr = parseFloat(step.querySelector(`[name='monthly_metrics[${idx}][mrr]']`)?.value || 0)
      const burn = parseFloat(step.querySelector(`[name='monthly_metrics[${idx}][burn_rate]']`)?.value || 0)
      // Net Growth
      const netGrowth = newCustomers - churned
      const netGrowthEl = step.querySelector(`[data-onboarding-target='netGrowth${idx}']`)
      if (netGrowthEl) netGrowthEl.textContent = netGrowth
      // Runway
      let runway = '-'
      if (burn > 0) {
        runway = ((cash + mrr) / burn).toFixed(1)
      }
      const runwayEl = step.querySelector(`[data-onboarding-target='runway${idx}']`)
      if (runwayEl) runwayEl.textContent = runway
    })
  }
}
