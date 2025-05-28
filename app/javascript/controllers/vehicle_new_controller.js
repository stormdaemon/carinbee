import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="vehicle-new"
export default class extends Controller {
  static targets = ["createButton", "beeIcon"]

  connect() {
    this.initializeAnimation()
  }

  initializeAnimation() {
    if (this.hasCreateButtonTarget && this.hasBeeIconTarget) {
      this.beeIconTarget.classList.remove('flying-bee-create-vehicle')
      this.isHovering = false
      this.hasFlown = false
    }
  }

  mouseEnter() {
    if (!this.isHovering) {
      this.isHovering = true
      this.hasFlown = false
      // Arrêter l'animation de pulsation
      this.beeIconTarget.classList.remove('bee-pulse')
    }
    if (!this.hasFlown) {
      this.beeIconTarget.classList.add('flying-bee-create-vehicle')
      this.hasFlown = true
    }
  }

  mouseLeave() {
    this.isHovering = false
    // Redémarrer l'animation de pulsation après un délai
    setTimeout(() => {
      if (!this.isHovering) {
        this.beeIconTarget.classList.remove('flying-bee-create-vehicle')
        this.beeIconTarget.classList.add('bee-pulse')
        this.hasFlown = false
      }
    }, 1000)
  }
} 