import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { metrics: String }

  connect() {
    try {
      this.metrics = this.metricsValue ? JSON.parse(this.metricsValue) : []
    } catch (e) {
      this.metrics = []
    }
    this._chartRetries = 0
    this.setupCharts()
  }

  setupCharts() {
    if (typeof Chart === 'undefined') {
      if (this._chartRetries < 10) {
        this._chartRetries += 1
        setTimeout(() => this.setupCharts(), 200)
        return
      }
      return
    }
    const labels = this.metrics.map(m => m.period)
    const mrrs = this.metrics.map(m => m.mrr == null ? null : Number(m.mrr))
    const customers = this.metrics.map(m => m.customers == null ? null : Number(m.customers))
    const runways = this.metrics.map(m => m.runway == null ? null : Number(m.runway))
    const isProj = this.metrics.map(m => !!m.is_projection)

    // Split actuals vs projections by masking values
    const mrrActual = mrrs.map((v, i) => isProj[i] ? null : v)
    const mrrProj = mrrs.map((v, i) => isProj[i] ? v : null)

    const mrrCanvas = document.getElementById('mrrChart')
    if (mrrCanvas) {
      new Chart(mrrCanvas.getContext('2d'), {
        type: 'line',
        data: {
          labels: labels,
          datasets: [
            {
              label: 'MRR (Actual)',
              data: mrrActual,
              borderColor: '#6D28D9',
              backgroundColor: 'rgba(109,40,217,0.06)',
              tension: 0.2,
              spanGaps: true
            },
            {
              label: 'MRR (Projection)',
              data: mrrProj,
              borderColor: '#A78BFA',
              borderDash: [6,6],
              backgroundColor: 'rgba(167,139,250,0.03)',
              tension: 0.2,
              spanGaps: true
            }
          ]
        },
        options: {
          responsive: true,
          scales: {
            y: { beginAtZero: true }
          },
          plugins: { legend: { display: true } }
        }
      })
    }

    const customersCanvas = document.getElementById('customersChart')
    if (customersCanvas) {
      new Chart(customersCanvas.getContext('2d'), {
        type: 'line',
        data: {
          labels: labels,
          datasets: [
            { label: 'Customers', data: customers, borderColor: '#059669', backgroundColor: 'rgba(5,150,105,0.06)', tension: 0.2 }
          ]
        },
        options: { responsive: true, scales: { y: { beginAtZero: true } } }
      })
    }

    const runwayCanvas = document.getElementById('runwayChart')
    if (runwayCanvas) {
      new Chart(runwayCanvas.getContext('2d'), {
        type: 'line',
        data: {
          labels: labels,
          datasets: [
            { label: 'Runway (months)', data: runways, borderColor: '#D97706', backgroundColor: 'rgba(217,119,6,0.06)', tension: 0.2 }
          ]
        },
        options: { responsive: true, scales: { y: { beginAtZero: true } } }
      })
    }
  }
}
