import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.animateCards()
  }

  animateCards() {
    const cards = this.element.querySelectorAll('.rental-card')
    
    cards.forEach((card, index) => {
      card.style.opacity = '0'
      card.style.transform = 'translateY(20px)'
      
      setTimeout(() => {
        card.style.transition = 'all 0.5s ease'
        card.style.opacity = '1'
        card.style.transform = 'translateY(0)'
      }, index * 100)
    })
  }
} 