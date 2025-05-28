import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static values = { apiKey: String }
  static targets = ["address"]

  connect() {
    console.log("Address autocomplete controller connected")
    this.setupSimpleGeocoder()
  }

  setupSimpleGeocoder() {
    // Sauvegarder la valeur existante
    const existingValue = this.addressTarget.value
    
    // Masquer l'input original
    this.addressTarget.style.display = 'none'
    
    // Créer un input de remplacement simple
    this.geocoderInput = document.createElement('input')
    this.geocoderInput.type = 'text'
    this.geocoderInput.className = 'form-control'
    this.geocoderInput.placeholder = 'ex: Paris'
    this.geocoderInput.value = existingValue || ''
    
    // Insérer après l'input original
    this.addressTarget.parentNode.insertBefore(this.geocoderInput, this.addressTarget.nextSibling)
    
    // Synchroniser les valeurs
    this.geocoderInput.addEventListener('input', () => {
      this.addressTarget.value = this.geocoderInput.value
    })
    
    // Ajouter l'autocomplétion Mapbox simple
    this.setupMapboxAutocomplete()
  }

  async setupMapboxAutocomplete() {
    // Import dynamique pour éviter les problèmes de chargement
    try {
      const response = await fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/paris.json?access_token=${this.apiKeyValue}&country=fr&limit=1`)
      console.log('Mapbox API accessible')
      
      // Setup de l'autocomplétion
      this.geocoderInput.addEventListener('input', this.debounce(this.handleSearch.bind(this), 300))
      
    } catch (error) {
      console.log('Erreur Mapbox API:', error)
    }
  }

  async handleSearch(event) {
    const query = event.target.value.trim()
    if (query.length < 3) {
      this.hideSuggestions()
      return
    }

    try {
      const response = await fetch(
        `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(query)}.json?access_token=${this.apiKeyValue}&country=fr&types=place,locality,neighborhood,address&limit=5`
      )
      const data = await response.json()
      this.showSuggestions(data.features || [])
    } catch (error) {
      console.log('Erreur de recherche:', error)
    }
  }

  showSuggestions(features) {
    this.hideSuggestions()
    
    if (features.length === 0) return
    
    this.suggestionsList = document.createElement('div')
    this.suggestionsList.className = 'list-group position-absolute w-100'
    this.suggestionsList.style.zIndex = '1000'
    this.suggestionsList.style.top = '100%'
    this.suggestionsList.style.left = '0'
    
    // Wrapper avec position relative
    this.geocoderInput.parentNode.style.position = 'relative'
    
    features.forEach(feature => {
      const item = document.createElement('button')
      item.type = 'button'
      item.className = 'list-group-item list-group-item-action'
      item.textContent = feature.place_name
      item.addEventListener('click', () => {
        this.geocoderInput.value = feature.place_name
        this.addressTarget.value = feature.place_name
        this.hideSuggestions()
      })
      this.suggestionsList.appendChild(item)
    })
    
    this.geocoderInput.parentNode.appendChild(this.suggestionsList)
  }

  hideSuggestions() {
    if (this.suggestionsList && this.suggestionsList.parentNode) {
      this.suggestionsList.parentNode.removeChild(this.suggestionsList)
      this.suggestionsList = null
    }
  }

  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  }

  disconnect() {
    console.log("Address autocomplete controller disconnecting")
    
    this.hideSuggestions()
    
    // Supprimer l'input de remplacement
    if (this.geocoderInput && this.geocoderInput.parentNode) {
      this.geocoderInput.parentNode.removeChild(this.geocoderInput)
    }
    
    // Remettre l'input original visible
    if (this.addressTarget) {
      this.addressTarget.style.display = 'block'
    }
  }
}