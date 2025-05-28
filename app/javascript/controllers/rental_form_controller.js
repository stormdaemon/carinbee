import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startDate", "endDate", "summary", "summaryStartDate", "summaryEndDate", "summaryDuration", "summaryDays", "summaryTotal", "form"]
  static values = { dailyPrice: Number }

  connect() {
    this.initializeDateCalculations()
    this.initializeFormValidation()
  }

  initializeDateCalculations() {
    if (this.hasStartDateTarget && this.hasEndDateTarget) {
      this.startDateTarget.addEventListener('change', () => this.calculateAndUpdateSummary())
      this.endDateTarget.addEventListener('change', () => this.calculateAndUpdateSummary())
      this.startDateTarget.addEventListener('change', () => this.updateEndDateMin())
      
      // Calcul initial si les dates sont déjà remplies
      this.calculateAndUpdateSummary()
    }
  }

  initializeFormValidation() {
    if (this.hasFormTarget) {
      this.formTarget.addEventListener('submit', (event) => this.validateForm(event))
    }
  }

  formatDate(dateString) {
    if (!dateString) return '-'
    const date = new Date(dateString)
    return date.toLocaleDateString('fr-FR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric'
    })
  }

  calculateAndUpdateSummary() {
    const startDate = this.startDateTarget.value
    const endDate = this.endDateTarget.value

    if (startDate && endDate) {
      const start = new Date(startDate)
      const end = new Date(endDate)

      if (end > start) {
        const timeDiff = end.getTime() - start.getTime()
        const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24))
        const totalPrice = daysDiff * this.dailyPriceValue

        // Mettre à jour le résumé
        this.summaryStartDateTarget.textContent = this.formatDate(startDate)
        this.summaryEndDateTarget.textContent = this.formatDate(endDate)
        this.summaryDurationTarget.textContent = daysDiff + ' jour' + (daysDiff > 1 ? 's' : '')
        this.summaryDaysTarget.textContent = daysDiff
        this.summaryTotalTarget.textContent = totalPrice.toLocaleString('fr-FR') + ' €'

        // Afficher le résumé
        this.summaryTarget.style.display = 'block'
      } else {
        this.summaryTarget.style.display = 'none'
      }
    } else {
      this.summaryTarget.style.display = 'none'
    }
  }

  updateEndDateMin() {
    if (this.startDateTarget.value) {
      const nextDay = new Date(this.startDateTarget.value)
      nextDay.setDate(nextDay.getDate() + 1)
      this.endDateTarget.min = nextDay.toISOString().split('T')[0]

      // Si la date de fin est antérieure à la nouvelle date minimum, la réinitialiser
      if (this.endDateTarget.value && new Date(this.endDateTarget.value) <= new Date(this.startDateTarget.value)) {
        this.endDateTarget.value = ''
      }
    }
  }

  validateForm(event) {
    const startDate = this.startDateTarget.value
    const endDate = this.endDateTarget.value

    if (!startDate || !endDate) {
      event.preventDefault()
      event.stopPropagation()

      if (!startDate) {
        this.startDateTarget.classList.add('is-invalid')
      }
      if (!endDate) {
        this.endDateTarget.classList.add('is-invalid')
      }
    } else if (new Date(endDate) <= new Date(startDate)) {
      event.preventDefault()
      event.stopPropagation()
      this.endDateTarget.classList.add('is-invalid')
    }

    this.formTarget.classList.add('was-validated')
  }
} 