import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["beeIcon", "button"]
  static values = { 
    type: String, // "update" pour le bouton de mise à jour, "header" pour l'abeille du header
    autoPlay: { type: Boolean, default: false }
  }

  connect() {
    this.isAnimating = false
    this.hasFlown = false
    
    if (this.typeValue === "update") {
      this.initializeUpdateAnimation()
    } else if (this.typeValue === "header") {
      this.initializeHeaderAnimation()
      if (this.autoPlayValue) {
        setTimeout(() => {
          this.triggerBeeAnimation()
        }, 1000)
      }
    }
  }

  initializeUpdateAnimation() {
    if (!this.hasBeeIconTarget || !this.hasButtonTarget) return
    
    // Determine which CSS class to use based on button ID
    let flyingClass = 'flying-bee-update'
    const buttonId = this.buttonTarget.id
    
    if (buttonId === 'updateProfileSubmitButton') {
      flyingClass = 'flying-bee-update-profile'
    } else if (buttonId === 'editProfileButton') {
      flyingClass = 'flying-bee-from-card'
    } else if (buttonId === 'addCarButton') {
      flyingClass = 'flying-bee-from-add-car-button'
    }
    
    this.beeIconTarget.classList.remove(flyingClass)
    let isHovering = false
    this.hasFlown = false

    this.buttonTarget.addEventListener('mouseenter', () => {
      if (!isHovering) {
        isHovering = true
        this.hasFlown = false
        this.beeIconTarget.classList.remove('bee-pulse')
      }
      if (!this.hasFlown) {
        this.beeIconTarget.classList.add(flyingClass)
        this.hasFlown = true
      }
    })
    
    this.buttonTarget.addEventListener('mouseleave', () => {
      isHovering = false
      setTimeout(() => {
        if (!isHovering) {
          this.beeIconTarget.classList.remove(flyingClass)
          this.beeIconTarget.classList.add('bee-pulse')
          this.hasFlown = false
        }
      }, 1000)
    })
  }

  initializeHeaderAnimation() {
    if (!this.hasBeeIconTarget) return
    this.beeIconTarget.addEventListener('click', (e) => {
      e.preventDefault()
      this.triggerBeeAnimation()
    })
  }

  triggerBeeAnimation() {
    if (this.isAnimating) return
    this.isAnimating = true

    // Suppression de l'effet de zoom
    // document.body.classList.add('page-zoom')
    
    this.playBeeSound()
    this.beeIconTarget.classList.add('bee-flutter')
    this.createGlitterEffect(this.beeIconTarget.parentElement, 1000)
    
    setTimeout(() => {
      this.createHoneyTrail(this.beeIconTarget.parentElement)
    }, 200)
    
    setTimeout(() => {
      this.createMultipleBees(this.beeIconTarget.parentElement)
    }, 500)
    
    setTimeout(() => {
      this.beeIconTarget.classList.add('bee-flying')
    }, 100)

    setTimeout(() => {
      this.createGlitterEffect(this.beeIconTarget.parentElement, 2500)
    }, 3800)

    setTimeout(() => {
      this.createHoneyTrail(this.beeIconTarget.parentElement)
      setTimeout(() => {
        this.createGlitterEffect(this.beeIconTarget.parentElement, 1500)
      }, 200)
    }, 3900)

    setTimeout(() => {
      this.beeIconTarget.classList.remove('bee-flying', 'bee-flutter')
      // Suppression également de la ligne qui retire la classe page-zoom
      // document.body.classList.remove('page-zoom')
      this.isAnimating = false
    }, 4500)
  }

  createGlitterEffect(parentElement, duration = 3000) {
    const glitterTrail = document.createElement('div')
    glitterTrail.className = 'glitter-trail'
    parentElement.style.position = 'relative'
    parentElement.appendChild(glitterTrail)
    
    for (let i = 0; i < 20; i++) {
      const glitterParticle = document.createElement('div')
      glitterParticle.className = 'glitter-particle'
      
      const angle = (i / 20) * 2 * Math.PI
      const radius = 15 + Math.random() * 25
      const x = Math.cos(angle) * radius
      const y = Math.sin(angle) * radius
      
      glitterParticle.style.left = `calc(50% + ${x}px)`
      glitterParticle.style.top = `calc(50% + ${y}px)`
      glitterParticle.style.transform = 'translate(-50%, -50%)'
      
      const size = 4 + Math.random() * 6
      glitterParticle.style.width = `${size}px`
      glitterParticle.style.height = `${size}px`
      
      glitterParticle.style.animationDelay = `${Math.random() * 0.8}s`
      glitterParticle.style.animation = `glitterEffect ${2 + Math.random() * 2}s ease-out forwards, sparkle ${1 + Math.random()}s ease-in-out infinite alternate`
      
      glitterTrail.appendChild(glitterParticle)
    }
    
    glitterTrail.classList.add('glitter-active')
    
    setTimeout(() => {
      glitterTrail.remove()
    }, duration)
    
    return glitterTrail
  }

  createHoneyTrail(parentElement) {
    const honeyTrail = document.createElement('div')
    honeyTrail.className = 'honey-trail'
    parentElement.appendChild(honeyTrail)
    
    for (let i = 0; i < 15; i++) {
      const honeyDrop = document.createElement('div')
      honeyDrop.style.position = 'absolute'
      honeyDrop.style.width = `${4 + Math.random() * 6}px`
      honeyDrop.style.height = `${4 + Math.random() * 6}px`
      honeyDrop.style.borderRadius = '50%'
      honeyDrop.style.left = `${45 + Math.random() * 10}%`
      honeyDrop.style.top = `${45 + Math.random() * 10}%`
      honeyDrop.style.animation = `honeyTrail ${1.5 + Math.random()}s ease-out forwards`
      honeyDrop.style.animationDelay = `${i * 0.1}s`
      honeyDrop.style.zIndex = '11'
      
      honeyTrail.appendChild(honeyDrop)
    }
    
    setTimeout(() => {
      honeyTrail.remove()
    }, 3000)
    
    return honeyTrail
  }

  createMultipleBees(parentElement) {
    const beeCount = 3
    const bees = []
    
    for (let i = 0; i < beeCount; i++) {
      const bee = document.createElement('img')
      bee.src = 'https://i.postimg.cc/1Xf6vLRL/image-1-removebg-preview-1.png'
      bee.style.position = 'absolute'
      bee.style.width = '35px'
      bee.style.height = '35px'
      bee.style.top = '50%'
      bee.style.left = '50%'
      bee.style.transform = 'translate(-50%, -50%)'
      bee.style.opacity = '0.7'
      bee.style.zIndex = '20'
      bee.style.pointerEvents = 'none'
      
      bee.style.animation = `beeEscape ${4 + i * 0.5}s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards`
      bee.style.animationDelay = `${i * 0.3}s`
      
      parentElement.appendChild(bee)
      bees.push(bee)
      
      setTimeout(() => {
        bee.remove()
      }, (4 + i * 0.5 + i * 0.3) * 1000)
    }
    
    return bees
  }

  playBeeSound() {
    if (typeof AudioContext !== 'undefined' || typeof webkitAudioContext !== 'undefined') {
      const audioContext = new (window.AudioContext || window.webkitAudioContext)()
      
      const oscillator = audioContext.createOscillator()
      const gainNode = audioContext.createGain()
      
      oscillator.connect(gainNode)
      gainNode.connect(audioContext.destination)
      
      oscillator.frequency.setValueAtTime(220, audioContext.currentTime)
      oscillator.frequency.exponentialRampToValueAtTime(180, audioContext.currentTime + 0.5)
      oscillator.frequency.exponentialRampToValueAtTime(250, audioContext.currentTime + 1)
      oscillator.frequency.exponentialRampToValueAtTime(200, audioContext.currentTime + 2)
      
      gainNode.gain.setValueAtTime(0, audioContext.currentTime)
      gainNode.gain.linearRampToValueAtTime(0.1, audioContext.currentTime + 0.1)
      gainNode.gain.exponentialRampToValueAtTime(0.05, audioContext.currentTime + 2)
      gainNode.gain.linearRampToValueAtTime(0, audioContext.currentTime + 2.5)
      
      oscillator.type = 'sawtooth'
      oscillator.start(audioContext.currentTime)
      oscillator.stop(audioContext.currentTime + 2.5)
    }
  }
} 