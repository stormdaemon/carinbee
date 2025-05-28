import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]
  
  connect() {
    this.timeout = null
    this.delay = 300 // Délai en millisecondes avant soumission
  }

  submit() {
    // Annuler le timeout précédent s'il existe
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    // Créer un nouveau timeout
    this.timeout = setTimeout(() => {
      // Vérifier si au moins un champ a une valeur pour éviter les requêtes vides inutiles
      const hasValue = this.fieldTargets.some(field => field.value.trim() !== '')
      
      // Toujours soumettre, même si vide, pour permettre de réinitialiser les filtres
      this.element.requestSubmit()
    }, this.delay)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
} 