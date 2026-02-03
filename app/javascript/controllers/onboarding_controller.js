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
      if (next) next.addEventListener('click', () => this.nextStep(idx + 1))
      if (prev) prev.addEventListener('click', () => this.showStep(idx - 1))
    })
    // Ensure only the active step's inputs participate in browser validation
    let initialIdx = this.steps.findIndex(s => !s.classList.contains('hidden'))
    if (initialIdx < 0) initialIdx = 0
    this.showStep(initialIdx)
    this.updateDisabledStates(initialIdx)
    this.recalcAll()
    // Wire up the "Submit All" button to validate all steps then submit
    const submitAll = this.element.querySelector("input[type='submit']:not([name='save_step']), button[type='submit']:not([name='save_step'])")
    if (submitAll) submitAll.addEventListener('click', (e) => this.validateAllThenSubmit(e))
    // Also intercept the form submit (covers Enter key submissions) and route through our validator
    const form = this.element.querySelector('form')
    if (form) {
      form.addEventListener('submit', (e) => this.handleFormSubmit(e))
    }
  }

  showStep(idx) {
    this.steps.forEach((step, i) => {
      step.classList.toggle('hidden', i !== idx)
    })
    this.tabs.forEach((tab, i) => {
      tab.classList.toggle('tab-active', i === idx)
    })
    this.updateDisabledStates(idx)
  }

  nextStep(idx) {
    const currentIdx = idx - 1
    const current = this.steps[currentIdx]
    if (!current) return this.showStep(idx)
    // Validate required fields in current step before advancing
    const requiredInputs = Array.from(current.querySelectorAll('[required]'))
    const missing = requiredInputs.filter(i => {
      const v = i.value
      return v === null || v === undefined || (String(v).trim() === '')
    })
    // remove existing inline missing alert
    const existingAlert = current.querySelector('.onboarding-missing-alert')
    if (existingAlert) existingAlert.remove()
    if (missing.length > 0) {
      const alert = document.createElement('div')
      alert.className = 'alert alert-error onboarding-missing-alert mt-2'
      alert.innerHTML = `<div><svg xmlns="http://www.w3.org/2000/svg" class="stroke-current flex-shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-12.728 12.728M5.636 5.636l12.728 12.728"/></svg><span>Please fill required fields for this month before moving on.</span></div>`
      const body = current.querySelector('.card-body') || current
      body.prepend(alert)
      // highlight first missing
      missing[0].focus()
      return
    }
    this.showStep(idx)
  }

  updateDisabledStates(activeIdx) {
    this.steps.forEach((step, i) => {
      const controls = Array.from(step.querySelectorAll('input, select, textarea'))
      controls.forEach(c => {
        // Keep submit/button/hidden inputs enabled so form controls that are not validation-related still work
        if (c.tagName.toLowerCase() === 'input') {
          const t = c.type
          if (t === 'submit' || t === 'button' || t === 'hidden') {
            c.disabled = false
            return
          }
        }
        c.disabled = (i !== activeIdx)
      })
    })
  }

  enableAllControls() {
    this.steps.forEach((step) => {
      const controls = Array.from(step.querySelectorAll('input, select, textarea'))
      controls.forEach(c => {
        // never enable disabled for hidden submit/button controls that shouldn't submit, but enable inputs/selects/textareas
        if (c.tagName.toLowerCase() === 'input') {
          const t = c.type
          if (t === 'submit' || t === 'button') return
        }
        c.disabled = false
      })
    })
  }

  validateAllThenSubmit(event) {
    if (event && typeof event.preventDefault === 'function') event.preventDefault()
    const form = this.element.querySelector('form')
    let firstMissing = null
    this.steps.forEach((step, idx) => {
      if (firstMissing) return
      const requiredInputs = Array.from(step.querySelectorAll('[required]'))
      requiredInputs.forEach(i => {
        const v = i.value
        const empty = v === null || v === undefined || (String(v).trim() === '')
        if (empty && !firstMissing) firstMissing = { input: i, idx }
      })
    })
    if (firstMissing) {
      const step = this.steps[firstMissing.idx]
      const existingAlert = step.querySelector('.onboarding-missing-alert')
      if (existingAlert) existingAlert.remove()
      const alert = document.createElement('div')
      alert.className = 'alert alert-error onboarding-missing-alert mt-2'
      alert.innerHTML = `<div><svg xmlns="http://www.w3.org/2000/svg" class="stroke-current flex-shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-12.728 12.728M5.636 5.636l12.728 12.728"/></svg><span>Please fill required fields for this month before submitting all.</span></div>`
      const body = step.querySelector('.card-body') || step
      body.prepend(alert)
      this.showStep(firstMissing.idx)
      setTimeout(() => { try { firstMissing.input.focus() } catch(e) {} }, 300)
      return
    }
    // All fields present — enable controls and submit the form
    this.enableAllControls()
    if (form) form.submit()
  }

  handleFormSubmit(event) {
    // If submit originated from a per-step save button, let it proceed
    try {
      const submitter = event.submitter || document.activeElement
      if (submitter && submitter.name === 'save_step') return
    } catch (e) {
      // ignore
    }
    // Otherwise, validate all and only submit when valid
    this.validateAllThenSubmit(event)
  }

  recalc(event) {
    this.recalcAll()
  }

  animateBadge(event) {
    // animate badges for the step containing the changed input
    const input = event.currentTarget
    const stepEl = input.closest('.onboarding-step')
    if (!stepEl) return
    const idx = stepEl.dataset.step
    const badgeEls = stepEl.querySelectorAll('[data-onboarding-target]')
    badgeEls.forEach(el => {
      el.classList.add('badge-animate')
      setTimeout(() => el.classList.remove('badge-animate'), 300)
    })
  }

  toggleAccordion(event) {
    event.preventDefault()
    const trigger = event.currentTarget
    const idx = trigger.dataset.accordionIdx
    const key = trigger.dataset.accordionKey
    if (typeof idx === 'undefined' || typeof key === 'undefined') return
    const selector = `.onboarding-accordion[data-accordion-idx='${idx}'][data-accordion-key='${key}']`
    const target = document.querySelector(selector)
    if (!target) {
      // No inline accordion — toggle the left-side FAQ card body instead
      const explain = document.querySelector(`[data-explain-key='${key}']`)
      if (!explain) return
      const body = explain.querySelector('.definition-body')
      const btn = explain.querySelector(`[data-action\="click->onboarding#toggleDefinition\"]`) || explain.querySelector('button')
      const isOpen = body && !body.classList.contains('hidden')
      // close other definition bodies (single-open behavior)
      document.querySelectorAll('.definition-body').forEach(d => d.classList.add('hidden'))
      document.querySelectorAll('[data-explain-key]').forEach(c => {
        const b = c.querySelector('.definition-body')
        const toggleBtn = c.querySelector('button[data-action\="click->onboarding#toggleDefinition\"], button')
        if (b) b.classList.add('hidden')
        if (toggleBtn) toggleBtn.setAttribute('aria-expanded', 'false')
      })
      if (!isOpen && body) {
        body.classList.remove('hidden')
        if (btn) btn.setAttribute('aria-expanded', 'true')
        explain.scrollIntoView({ behavior: 'smooth', block: 'center' })
        explain.classList.add('ring', 'ring-nailab-teal', 'ring-opacity-40')
        setTimeout(() => explain.classList.remove('ring', 'ring-nailab-teal', 'ring-opacity-40'), 1600)
      }
      return
    }
    const isOpen = !target.classList.contains('hidden')
    // close all accordions first (single-open behavior)
    document.querySelectorAll('.onboarding-accordion').forEach(a => a.classList.add('hidden'))
    if (!isOpen) {
      target.classList.remove('hidden')
      // focus first child for accessibility
      const focusable = target.querySelector('a, button, input')
      if (focusable) focusable.focus()
    }
  }

  toggleDefinition(event) {
    event.preventDefault()
    const key = event.currentTarget.dataset.defKey
    if (!key) return
    const explain = document.querySelector(`[data-explain-key='${key}']`)
    if (!explain) return
    const body = explain.querySelector('.definition-body')
    const btn = event.currentTarget
    const isOpen = body && !body.classList.contains('hidden')
    // close all
    document.querySelectorAll('[data-explain-key]').forEach(c => {
      const b = c.querySelector('.definition-body')
      const t = c.querySelector('.definition-teaser')
      const toggleBtn = c.querySelector('button[data-action\="click->onboarding#toggleDefinition\"]')
      if (b) b.classList.add('hidden')
      if (t) t.classList.remove('hidden')
      if (toggleBtn) toggleBtn.setAttribute('aria-expanded', 'false')
    })
    if (!isOpen && body) {
      body.classList.remove('hidden')
      const teaser = explain.querySelector('.definition-teaser')
      if (teaser) teaser.classList.add('hidden')
      btn.setAttribute('aria-expanded', 'true')
      explain.scrollIntoView({ behavior: 'smooth', block: 'center' })
      explain.classList.add('ring', 'ring-nailab-teal', 'ring-opacity-40')
      setTimeout(() => explain.classList.remove('ring', 'ring-nailab-teal', 'ring-opacity-40'), 1600)
    }
  }

  openLearnMore(event) {
    event.preventDefault()
    const el = document.getElementById('onboarding-learnmore')
    if (el) el.classList.remove('hidden')
  }

  closeLearnMore(event) {
    if (event) event.preventDefault()
    const el = document.getElementById('onboarding-learnmore')
    if (el) el.classList.add('hidden')
  }

  recalcAll() {
    this.steps.forEach((step, idx) => {
      const newCustomers = parseInt(step.querySelector(`[name='monthly_metrics[${idx}][new_paying_customers]']`)?.value || 0)
      const churned = parseInt(step.querySelector(`[name='monthly_metrics[${idx}][churned_customers]']`)?.value || 0)
      const cashRaw = step.querySelector(`[name='monthly_metrics[${idx}][cash_at_hand]']`)?.value
      const cash = cashRaw && cashRaw !== '' ? parseFloat(cashRaw) : null
      const mrrRaw = step.querySelector(`[name='monthly_metrics[${idx}][mrr]']`)?.value
      const mrr = mrrRaw && mrrRaw !== '' ? parseFloat(mrrRaw) : null
      const burnRaw = step.querySelector(`[name='monthly_metrics[${idx}][burn_rate]']`)?.value
      const burn = burnRaw && burnRaw !== '' ? parseFloat(burnRaw) : null

      // MRR display (show at beginning) — format with thousands
      const mrrEl = step.querySelector(`[data-onboarding-target='mrr${idx}']`)
      if (mrrEl) mrrEl.textContent = mrr ? Math.round(mrr).toLocaleString() : '—'

      // Net Growth (customers)
      const netGrowth = newCustomers - churned
      const netGrowthEl = step.querySelector(`[data-onboarding-target='netGrowth${idx}']`)
      if (netGrowthEl) {
        netGrowthEl.textContent = (netGrowth > 0 ? `+${netGrowth}` : `${netGrowth}`)
        netGrowthEl.classList.remove('text-success','text-error')
        if (netGrowth > 0) netGrowthEl.classList.add('text-success')
        if (netGrowth < 0) netGrowthEl.classList.add('text-error')
      }

      // MRR change vs previous month (if available)
      let mrrChange = '—'
      let mrrChangePct = ''
      if (idx > 0) {
        const prevStep = this.steps[idx - 1]
        const prevMrrRaw = prevStep.querySelector(`[name='monthly_metrics[${idx - 1}][mrr]']`)?.value
        const prevHas = prevMrrRaw && prevMrrRaw !== ''
        if (mrr != null && prevHas) {
          const prevMrr = parseFloat(prevMrrRaw)
          const delta = (mrr - prevMrr)
          mrrChange = (delta > 0 ? `+${Math.round(delta)}` : `${Math.round(delta)}`)
          if (prevMrr !== 0) {
            const pct = (delta / Math.abs(prevMrr)) * 100
            mrrChangePct = `(${pct.toFixed(1)}%)`
          }
        } else {
          mrrChange = '—'
        }
      } else {
        mrrChange = 'Baseline'
      }
      const mrrChangeEl = step.querySelector(`[data-onboarding-target='mrrChange${idx}']`)
      const mrrChangePctEl = step.querySelector(`[data-onboarding-target='mrrChangePct${idx}']`)
      if (mrrChangeEl) mrrChangeEl.textContent = mrrChange
      if (mrrChangePctEl) mrrChangePctEl.textContent = mrrChangePct
      if (mrrChangeEl) {
        mrrChangeEl.classList.remove('text-success','text-error')
        if (mrrChange !== '—' && mrrChange !== 'Baseline') {
          const numeric = parseFloat(mrrChange.replace('+',''))
          if (!Number.isNaN(numeric)) {
            if (numeric > 0) mrrChangeEl.classList.add('text-success')
            if (numeric < 0) mrrChangeEl.classList.add('text-error')
          }
        }
      }

      // Runway: improved handling. If burn > 0 use cash / burn; if burn == 0 and cash>0 show infinity; else '-'
      let runway = '-'
      if (burn > 0) {
        const r = cash / burn
        runway = r > 0 ? r.toFixed(1) : '-'
      } else if (burn === 0 && cash > 0) {
        runway = '∞'
      }
      const runwayEl = step.querySelector(`[data-onboarding-target='runway${idx}']`)
      if (runwayEl) runwayEl.textContent = runway

      // Update projected total customers for the visible step
      try {
        const baseEl = document.getElementById('onboarding-current-customers')
        if (baseEl && !step.classList.contains('hidden')) {
          const baseRaw = baseEl.dataset.baseCustomers || baseEl.textContent || '0'
          const base = parseInt(String(baseRaw).replace(/[^0-9\-]/g, '')) || 0
          const projected = base + (isNaN(newCustomers) ? 0 : newCustomers) - (isNaN(churned) ? 0 : churned)
          baseEl.textContent = projected.toLocaleString()
        }
      } catch (e) {
        // ignore errors updating projected total
      }
    })
  }
}
