import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Ce controller sert d'initialisateur pour la page d'accueil
    // Les autres contrôleurs comme typed_text et bee_animation s'initialiseront automatiquement
    console.log("Home controller connected!")
  }

  // On peut ajouter ici d'autres fonctions spécifiques à la page d'accueil si nécessaire
}
