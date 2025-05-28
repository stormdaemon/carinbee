import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["map"]
  
  connect() {
    this.isSticky = false
    
    if (window.innerWidth > 991) {
      this.setupSticky()
    }
    
    window.addEventListener('resize', this.handleResize.bind(this))
  }

  disconnect() {
    if (this.handleScroll) {
      window.removeEventListener('scroll', this.handleScroll)
    }
    window.removeEventListener('resize', this.handleResize.bind(this))
  }

  setupSticky() {
    if (!this.hasMapTarget) return
    
    setTimeout(() => {
      if (this.hasMapTarget) {
        if (this.handleScroll) {
          window.removeEventListener('scroll', this.handleScroll)
        }
        
        this.handleScroll = this.handleScroll.bind(this)
        window.addEventListener('scroll', this.handleScroll)
        
        const rect = this.mapTarget.getBoundingClientRect()
        this.originalTop = rect.top + window.pageYOffset
        this.originalLeft = rect.left
        this.originalWidth = rect.width
      }
    }, 300)
  }

  handleScroll() {
    if (window.innerWidth <= 991 || !this.hasMapTarget) return

    const scrollTop = window.pageYOffset
    const shouldStick = scrollTop > this.originalTop - 20

    if (shouldStick && !this.isSticky) {
      this.makeSticky()
    } else if (!shouldStick && this.isSticky) {
      this.removeSticky()
    }
  }

  makeSticky() {
    if (!this.hasMapTarget) return
    
    this.placeholder = document.createElement('div')
    this.placeholder.style.height = this.mapTarget.offsetHeight + 'px'
    this.placeholder.style.width = this.originalWidth + 'px'
    this.mapTarget.parentNode.insertBefore(this.placeholder, this.mapTarget)
    
    // Sauvegarder les styles originaux
    this.originalStyles = {
      position: this.mapTarget.style.position,
      top: this.mapTarget.style.top,
      left: this.mapTarget.style.left,
      width: this.mapTarget.style.width,
      zIndex: this.mapTarget.style.zIndex,
      maxHeight: this.mapTarget.style.maxHeight,
      overflowY: this.mapTarget.style.overflowY
    }
    
    this.mapTarget.style.position = 'fixed'
    this.mapTarget.style.top = '20px'
    this.mapTarget.style.left = this.originalLeft + 'px'
    this.mapTarget.style.width = this.originalWidth + 'px'
    this.mapTarget.style.zIndex = '1000'
    this.mapTarget.style.maxHeight = 'calc(100vh - 40px)'
    this.mapTarget.style.overflowY = 'auto'
    
    this.isSticky = true
    
    // Attendre un peu avant de resize pour éviter les conflits
    setTimeout(() => {
      this.resizeMap()
    }, 50)
  }

  removeSticky() {
    if (!this.hasMapTarget) return
    
    if (this.placeholder && this.placeholder.parentNode) {
      this.placeholder.parentNode.removeChild(this.placeholder)
      this.placeholder = null
    }
    
    // Restaurer les styles originaux
    if (this.originalStyles) {
      Object.keys(this.originalStyles).forEach(key => {
        this.mapTarget.style[key] = this.originalStyles[key]
      })
    }
    
    this.isSticky = false
    
    // Attendre un peu avant de resize pour éviter les conflits
    setTimeout(() => {
      this.resizeMap()
    }, 50)
  }

  handleResize() {
    if (window.innerWidth <= 991) {
      this.removeSticky()
      if (this.handleScroll) {
        window.removeEventListener('scroll', this.handleScroll)
      }
    } else {
      this.setupSticky()
    }
  }

  reinitialize() {
    setTimeout(() => {
      this.removeSticky()
      if (window.innerWidth > 991) {
        this.setupSticky()
      }
    }, 200)
  }

  resizeMap() {
    const mapElement = this.mapTarget.querySelector('[data-controller="map"]')
    if (mapElement && mapElement.mapboxInstance) {
      // Utiliser requestAnimationFrame pour optimiser le rendu
      requestAnimationFrame(() => {
        mapElement.mapboxInstance.resize()
      })
    }
  }
} 