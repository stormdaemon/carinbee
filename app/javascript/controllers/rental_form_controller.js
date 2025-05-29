import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["summary", "summaryStartDate", "summaryEndDate", "summaryDuration", "summaryDays", "summaryTotal"]
  static values = { dailyPrice: Number }

  connect() {
    console.log("Rental form controller connected")
    console.log("Daily price:", this.dailyPriceValue)
  }

  // Écouter l'événement déclenché par Flatpickr
  handleDatesChanged(event) {
    console.log("Dates changed event received:", event.detail)
    const { startDate, endDate } = event.detail
    this.updateSummary(startDate, endDate)
  }

  // Mettre à jour le résumé
  updateSummary(startDate, endDate) {
    if (!this.hasSummaryTarget) {
      console.log("Summary target not found")
      return
    }

    if (startDate && endDate) {
      const start = new Date(startDate)
      const end = new Date(endDate)

      if (end > start) {
        const timeDiff = end.getTime() - start.getTime()
        const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24))
        const totalPrice = daysDiff * this.dailyPriceValue

        // Mettre à jour les éléments du résumé
        if (this.hasSummaryStartDateTarget) {
          this.summaryStartDateTarget.textContent = this.formatDate(start)
        }
        if (this.hasSummaryEndDateTarget) {
          this.summaryEndDateTarget.textContent = this.formatDate(end)
        }
        if (this.hasSummaryDurationTarget) {
          this.summaryDurationTarget.textContent = daysDiff + ' jour' + (daysDiff > 1 ? 's' : '')
        }
        if (this.hasSummaryDaysTarget) {
          this.summaryDaysTarget.textContent = daysDiff
        }
        if (this.hasSummaryTotalTarget) {
          this.summaryTotalTarget.textContent = totalPrice.toLocaleString('fr-FR') + ' €'
        }

        // Afficher le résumé
        this.summaryTarget.style.display = 'block'
      } else {
        this.summaryTarget.style.display = 'none'
      }
    } else {
      this.summaryTarget.style.display = 'none'
    }
  }

  formatDate(date) {
    return date.toLocaleDateString('fr-FR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric'
    })
  }

  // Validation du formulaire avant soumission
  validateForm(event) {
    const form = event.currentTarget
    const startDateField = form.querySelector('input[name="rental[rental_start_date]"]')
    const endDateField = form.querySelector('input[name="rental[rental_end_date]"]')

    if (!startDateField || !endDateField || !startDateField.value || !endDateField.value) {
      event.preventDefault()
      alert('Veuillez sélectionner les dates de location')
      return false
    }

    if (new Date(endDateField.value) <= new Date(startDateField.value)) {
      event.preventDefault()
      alert('La date de fin doit être après la date de début')
      return false
    }

    return true
  }
} 