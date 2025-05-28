import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]

  connect() {
    this.loadTypedLibrary()
  }

  async loadTypedLibrary() {
    if (typeof Typed === 'undefined') {
      await this.loadScript('https://unpkg.com/typed.js@2.0.16/dist/typed.umd.js')
    }
    this.initializeTyped()
  }

  loadScript(src) {
    return new Promise((resolve, reject) => {
      const script = document.createElement('script')
      script.src = src
      script.onload = resolve
      script.onerror = reject
      document.head.appendChild(script)
    })
  }

  initializeTyped() {
    const typedStrings = [
      "Ta voiture butine dans ton garage ? Fais-la voler ! 🐝",
      "Arrête de faire la reine fainéante, fais bosser tes ouvrières ! 🚗",
      "Ta caisse fait du miel pendant que tu dors 🍯💰",
      "Dans la ruche CARinBee, même les bourdons rapportent !",
      "Ta voiture : de drone de garage à abeille rentable 🐝💸",
      "Ton essaim de voitures peut nourrir toute la ruche !",
      "Bzzzz... C'est le bruit de ton compte en banque qui monte ! 💰",
      "Ta bagnole butine les euros dans tout le quartier 🐝€",
      "Fais danser ta voiture comme une abeille qui a trouvé le jackpot !",
      "CARinBee : où tes 4 roues deviennent 4 ailes ! 🚗✈️",
      "Ta caisse produit plus de miel que tes placements ! 🍯📈",
      "Rejoins la ruche ou reste un bourdon de parking ! 🐝🅿️",
      "Ta voiture : de chenille de garage à papillon rentable ! 🦋💸",
      "Bzzzz-ness is buzzing ! Ta caisse fait le buzz ET le biz ! 🐝💼"
    ]

    new Typed(this.outputTarget, {
      strings: typedStrings,
      typeSpeed: 50,
      backSpeed: 25,
      backDelay: 2000,
      startDelay: 500,
      loop: true,
      smartBackspace: true,
      showCursor: true,
      cursorChar: '<img src="https://i.postimg.cc/1Xf6vLRL/image-1-removebg-preview-1.png" style="height: 2em; vertical-align: middle;">',
    })
  }
} 