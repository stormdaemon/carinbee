import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl' // Don't forget this!

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  static targets = ["cityFilter"]

  // Coordonnées des principales villes françaises
  static cityCoordinates = {
    "paris": { lat: 48.8566, lng: 2.3522, zoom: 11 },
    "lyon": { lat: 45.7640, lng: 4.8357, zoom: 11 },
    "marseille": { lat: 43.2965, lng: 5.3698, zoom: 11 },
    "toulouse": { lat: 43.6047, lng: 1.4442, zoom: 11 },
    "nice": { lat: 43.7102, lng: 7.2620, zoom: 11 },
    "nantes": { lat: 47.2184, lng: -1.5536, zoom: 11 },
    "montpellier": { lat: 43.6110, lng: 3.8767, zoom: 11 },
    "strasbourg": { lat: 48.5734, lng: 7.7521, zoom: 11 },
    "bordeaux": { lat: 44.8378, lng: -0.5792, zoom: 11 },
    "lille": { lat: 50.6292, lng: 3.0573, zoom: 11 },
    "rennes": { lat: 48.1173, lng: -1.6778, zoom: 11 },
    "reims": { lat: 49.2583, lng: 4.0317, zoom: 11 },
    "saint-étienne": { lat: 45.4397, lng: 4.3872, zoom: 11 },
    "toulon": { lat: 43.1242, lng: 5.9280, zoom: 11 },
    "grenoble": { lat: 45.1885, lng: 5.7245, zoom: 11 }
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [2.3522, 46.6034], // Centre de la France
      zoom: 5
    })

    this.map.on('load', () => {
      this.#addMarkersToMap()
      this.#setupCityFiltering()
      this.#handleInitialCityFilter()
    })

    // Ajouter le contrôle de navigation
    this.map.addControl(new mapboxgl.NavigationControl())
  }

  #addMarkersToMap() {
    this.currentMarkers = []
    
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup({
        closeButton: true,
        closeOnClick: false,
        maxWidth: '320px'
      }).setHTML(marker.info_window_html)
  
      // Create a HTML element for your custom marker
      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html
  
      // Pass the element as an argument to the new marker
      const mapboxMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)
      
      // Stocker le marker avec ses données
      this.currentMarkers.push({
        marker: mapboxMarker,
        data: marker
      })
    })
  }

  #fitMapToMarkers() {
    if (this.markersValue.length === 0) return
    
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([marker.lng, marker.lat]))
    this.map.fitBounds(bounds, { 
      padding: { top: 50, bottom: 50, left: 50, right: 50 }, 
      maxZoom: 15, 
      duration: 1000 
    })
  }

  #handleInitialCityFilter() {
    // Vérifier s'il y a un paramètre city dans l'URL
    const urlParams = new URLSearchParams(window.location.search)
    const cityParam = urlParams.get('city')
    
    if (cityParam) {
      setTimeout(() => {
        this.#handleCityFilter(cityParam)
      }, 500) // Délai pour s'assurer que la carte est prête
    } else {
      // Pas de filtre ville, ajuster la vue aux markers
      setTimeout(() => {
        this.#fitMapToMarkers()
      }, 500)
    }
  }

  #setupCityFiltering() {
    // Écouter les changements sur le champ ville spécifiquement
    const cityInput = document.querySelector('input[name="city"]')
    if (cityInput) {
      cityInput.addEventListener('input', (event) => {
        // Débounce pour éviter trop d'appels
        clearTimeout(this.cityFilterTimeout)
        this.cityFilterTimeout = setTimeout(() => {
          this.#handleCityFilter(event.target.value)
        }, 300)
      })
    }

    // Écouter les soumissions de formulaire
    const searchForm = document.querySelector('form[action*="vehicles"]')
    if (searchForm) {
      searchForm.addEventListener('submit', (event) => {
        const cityValue = searchForm.querySelector('[name="city"]')?.value
        if (cityValue) {
          // Laisser le formulaire se soumettre normalement
          // Le zoom se fera après le rechargement via handleInitialCityFilter
        }
      })
    }
  }

  #handleCityFilter(cityValue) {
    if (!cityValue || cityValue === '') {
      // Aucune ville sélectionnée - afficher tous les markers
      this.#fitMapToMarkers()
      return
    }

    // Normaliser le nom de la ville
    const normalizedCity = cityValue.toLowerCase()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "") // Supprimer les accents
      .replace(/[^a-z0-9]/g, '') // Supprimer les caractères spéciaux

    // Chercher dans notre liste de coordonnées
    const cityCoords = Object.keys(this.constructor.cityCoordinates).find(city => 
      city.replace(/[^a-z0-9]/g, '').includes(normalizedCity) ||
      normalizedCity.includes(city.replace(/[^a-z0-9]/g, ''))
    )

    if (cityCoords) {
      const coords = this.constructor.cityCoordinates[cityCoords]
      this.#zoomToCity(coords)
    } else {
      // Essayer de filtrer les markers par localisation
      this.#filterMarkersByLocation(cityValue)
    }
  }

  #zoomToCity(coords) {
    this.map.flyTo({
      center: [coords.lng, coords.lat],
      zoom: coords.zoom,
      duration: 1500,
      essential: true
    })
  }

  #filterMarkersByLocation(location) {
    const filteredMarkers = this.currentMarkers.filter(item => 
      item.data.localization && 
      item.data.localization.toLowerCase().includes(location.toLowerCase())
    )

    if (filteredMarkers.length > 0) {
      const bounds = new mapboxgl.LngLatBounds()
      filteredMarkers.forEach(item => {
        bounds.extend([item.data.lng, item.data.lat])
      })
      
      this.map.fitBounds(bounds, { 
        padding: { top: 50, bottom: 50, left: 50, right: 50 }, 
        maxZoom: 13, 
        duration: 1500 
      })
    } else {
      // Aucun marker trouvé, essayer de zoomer sur la ville quand même
      this.#handleCityFilter(location)
    }
  }

  // Méthode publique pour zoomer sur une ville depuis l'extérieur
  zoomToCity(cityName) {
    this.#handleCityFilter(cityName)
  }
}