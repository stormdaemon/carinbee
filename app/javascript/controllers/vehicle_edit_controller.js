import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="vehicle-edit"
export default class extends Controller {
  static targets = ["updateButton", "beeIcon"]

  connect() {
    this.initializeAnimation()
  }

  initializeAnimation() {
    if (this.hasUpdateButtonTarget && this.hasBeeIconTarget) {
      this.beeIconTarget.classList.remove('flying-bee-update-vehicle')
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
      this.beeIconTarget.classList.add('flying-bee-update-vehicle')
      this.hasFlown = true
    }
  }

  mouseLeave() {
    this.isHovering = false
    // Redémarrer l'animation de pulsation après un délai
    setTimeout(() => {
      if (!this.isHovering) {
        this.beeIconTarget.classList.remove('flying-bee-update-vehicle')
        this.beeIconTarget.classList.add('bee-pulse')
        this.hasFlown = false
      }
    }, 1000)
  }
} 