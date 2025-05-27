// app/javascript/controllers/rental_calculator_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startDate", "endDate", "totalDisplay"]
  static values = { pricePerDay: Number }

  connect() {
    console.log("Rental calculator connected!");
    this.calculateTotal(); // Calculate on load if dates are pre-filled
  }

  calculateTotal() {
    const startDateInput = this.startDateTarget;
    const endDateInput = this.endDateTarget;
    const totalDisplay = this.totalDisplayTarget;

    const startDate = new Date(startDateInput.value);
    const endDate = new Date(endDateInput.value);

    if (startDateInput.value && endDateInput.value && endDate >= startDate) {
      const timeDiff = endDate.getTime() - startDate.getTime();
      const dayDiff = Math.ceil(timeDiff / (1000 * 3600 * 24)); // Difference in days
      const numberOfDays = dayDiff + 1; // Inclusive of start and end date

      if (numberOfDays > 0) {
        const totalCost = numberOfDays * this.pricePerDayValue;
        const formatter = new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' });
        totalDisplay.textContent = `${formatter.format(totalCost)} (pour ${numberOfDays} jour(s))`;
      } else {
        totalDisplay.textContent = "Date de fin doit être après la date de début.";
      }
    } else if (startDateInput.value && endDateInput.value && endDate < startDate) {
      totalDisplay.textContent = "Date de fin doit être après la date de début.";
    } else {
      totalDisplay.textContent = "Veuillez sélectionner les dates.";
    }
  }
}
