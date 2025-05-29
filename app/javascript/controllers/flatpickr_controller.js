import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static targets = ["dateRange"]
  
  connect() {
    console.log("Flatpickr controller connected")
    if (this.hasDateRangeTarget) {
      console.log("Date range target found")
      this.flatpickrInstance = flatpickr(this.dateRangeTarget, {
        mode: "range",
        dateFormat: "Y-m-d",
        minDate: "today",
        allowInput: false,
        clickOpens: true,
        altInput: true,
        altFormat: "d/m/Y",
        onChange: (selectedDates) => {
          console.log("Dates selected:", selectedDates)
          if (selectedDates.length === 2) {
            this.updateFormFields(selectedDates[0], selectedDates[1])
            // Déclencher un événement pour notifier le contrôleur rental_form
            this.dispatch("datesChanged", { 
              detail: { 
                startDate: selectedDates[0], 
                endDate: selectedDates[1] 
              } 
            })
          }
        },
        locale: {
          firstDayOfWeek: 1,
          weekdays: {
            shorthand: ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'],
            longhand: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi']
          },
          months: {
            shorthand: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'],
            longhand: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']
          }
        }
      })
      console.log("Flatpickr instance created:", this.flatpickrInstance)
    }
  }

  updateFormFields(startDate, endDate) {
    const form = this.element.closest('form')
    if (!form) return

    // Supprimer les anciens champs cachés s'ils existent
    const oldStartField = form.querySelector('input[name="rental[rental_start_date]"]')
    const oldEndField = form.querySelector('input[name="rental[rental_end_date]"]')
    if (oldStartField) oldStartField.remove()
    if (oldEndField) oldEndField.remove()

    // Créer les nouveaux champs cachés
    const startField = document.createElement('input')
    startField.type = 'hidden'
    startField.name = 'rental[rental_start_date]'
    startField.value = startDate.toISOString().split('T')[0]

    const endField = document.createElement('input')
    endField.type = 'hidden'
    endField.name = 'rental[rental_end_date]'
    endField.value = endDate.toISOString().split('T')[0]

    form.appendChild(startField)
    form.appendChild(endField)

    console.log("Form fields updated:", startField.value, endField.value)
  }

  disconnect() {
    if (this.flatpickrInstance) {
      this.flatpickrInstance.destroy()
    }
  }
}