import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash-message"
export default class extends Controller {
  static values = { 
    autoDismiss: Boolean, 
    delay: Number 
  }

  connect() {
    // Auto-dismiss si configuré
    if (this.autoDismissValue) {
      const delay = this.delayValue || 5000 // 5 secondes par défaut
      this.timeoutId = setTimeout(() => {
        this.dismiss()
      }, delay)
    }

    // Ajouter une animation d'entrée
    this.element.style.transform = 'translateX(100%)'
    this.element.style.opacity = '0'
    
    // Forcer un reflow puis animer
    this.element.offsetHeight
    
    this.element.style.transition = 'all 0.4s ease-out'
    this.element.style.transform = 'translateX(0)'
    this.element.style.opacity = '1'
  }

  disconnect() {
    // Nettoyer le timeout si le contrôleur est déconnecté
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  dismiss() {
    // Animation de sortie
    this.element.style.transition = 'all 0.3s ease-in'
    this.element.style.transform = 'translateX(100%)'
    this.element.style.opacity = '0'
    
    // Supprimer l'élément après l'animation
    setTimeout(() => {
      if (this.element.parentNode) {
        this.element.parentNode.removeChild(this.element)
      }
    }, 300)
  }

  // Action pour pause sur hover
  pauseAutoDismiss() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  // Action pour reprendre sur mouse leave
  resumeAutoDismiss() {
    if (this.autoDismissValue) {
      const delay = this.delayValue || 5000
      this.timeoutId = setTimeout(() => {
        this.dismiss()
      }, delay)
    }
  }
} 