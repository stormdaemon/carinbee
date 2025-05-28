import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["beeCard", "beeButton"]
  
  connect() {
    this.initializeAnimations()
  }

  initializeAnimations() {
    // Animation générique pour tous les boutons avec des abeilles
    this.beeButtonTargets.forEach((bee, index) => {
      const buttonId = bee.dataset.buttonId
      const button = document.getElementById(buttonId)
      
      if (button && bee) {
        this.initButtonAnimation(button, bee)
      }
    })
  }

  initButtonAnimation(button, bee) {
    bee.classList.remove('flying-bee-from-button')
    let isHovering = false
    let hasFlown = false

    button.addEventListener('mouseenter', () => {
      if (!isHovering) {
        isHovering = true
        hasFlown = false
        // Arrêter l'animation de pulsation de l'abeille principale
        if (this.hasBeeCardTarget) {
          this.beeCardTarget.classList.remove('bee-pulse')
        }
      }
      if (!hasFlown) {
        bee.classList.add('flying-bee-from-button')
        hasFlown = true
      }
    })

    button.addEventListener('mouseleave', () => {
      isHovering = false
      setTimeout(() => {
        if (!isHovering) {
          bee.classList.remove('flying-bee-from-button')
          // Redémarrer l'animation de pulsation
          if (this.hasBeeCardTarget) {
            this.beeCardTarget.classList.add('bee-pulse')
          }
          hasFlown = false
        }
      }, 1000)
    })
  }
} 