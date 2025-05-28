import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "dropdownToggle", "dropdownMenu", "toggler", "collapse"]

  connect() {
    this.initializeDropdown()
    this.initializeMobileMenu()
  }

  initializeDropdown() {
    if (!this.hasDropdownToggleTarget || !this.hasDropdownMenuTarget) return

    this.dropdownToggleTarget.addEventListener('click', (e) => {
      e.preventDefault()
      e.stopPropagation()
      this.toggleDropdown()
    })

    document.addEventListener('click', (e) => {
      if (!this.dropdownToggleTarget.contains(e.target) && !this.dropdownMenuTarget.contains(e.target)) {
        this.closeDropdown()
      }
    })

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        this.closeDropdown()
      }
    })

    window.addEventListener('resize', () => {
      if (this.dropdownMenuTarget.classList.contains('show')) {
        this.positionDropdown()
      }
    })
  }

  initializeMobileMenu() {
    if (!this.hasTogglerTarget || !this.hasCollapseTarget) return

    this.togglerTarget.addEventListener('click', () => {
      this.collapseTarget.classList.toggle('show')
    })
  }

  toggleDropdown() {
    const isOpen = this.dropdownMenuTarget.classList.contains('show')
    
    // Fermer tous les autres dropdowns
    document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
      menu.classList.remove('show')
    })
    
    // Toggle le dropdown actuel
    if (!isOpen) {
      this.dropdownMenuTarget.classList.add('show')
      setTimeout(() => this.positionDropdown(), 0)
    }
  }

  closeDropdown() {
    this.dropdownMenuTarget.classList.remove('show')
  }

  positionDropdown() {
    const rect = this.dropdownToggleTarget.getBoundingClientRect()
    const menuWidth = this.dropdownMenuTarget.offsetWidth
    const windowWidth = window.innerWidth
    
    // Vérifier si le dropdown dépasse à droite
    if (rect.right + menuWidth > windowWidth) {
      this.dropdownMenuTarget.style.right = '0'
      this.dropdownMenuTarget.style.left = 'auto'
      this.dropdownMenuTarget.style.transform = 'none'
    }
  }
} 