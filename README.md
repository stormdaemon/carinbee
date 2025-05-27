# CarInBee - Car Rental Platform

CarInBee est une plateforme de location de véhicules entre particuliers développée avec Ruby on Rails.

## Fonctionnalités

### Gestion des Utilisateurs
- Inscription et connexion via Devise
- Profils utilisateur avec informations personnelles
- Gestion des véhicules possédés
- Historique des locations

### Gestion des Véhicules
- Ajout de véhicules à louer
- Recherche et filtrage des véhicules disponibles
- Gestion de la disponibilité
- Photos et descriptions détaillées

### Système de Location
- Demandes de location avec dates
- Validation des disponibilités
- Statuts de location (pending, confirmed, completed, cancelled, refused)
- Calcul automatique des prix

### Système d'Avis
- Avis et notes après location
- Validation des avis (uniquement pour les locations terminées)
- Affichage des avis sur les profils

## Architecture

### Modèles

#### User
- Géré par Devise pour l'authentification
- Champs : email, first_name, last_name, age, address
- Relations : has_many :vehicles, has_many :rentals

#### Vehicle
- Champs : brand, model, daily_price, localization, number_of_places, category, fuel_type, kilometers, description, available
- Relations : belongs_to :user, has_many :rentals
- Validations complètes sur tous les champs

#### Rental
- Champs : rental_start_date, rental_end_date, total_price, status
- Relations : belongs_to :user, belongs_to :vehicle, has_many :reviews
- Validations complexes (dates, disponibilité, chevauchements)
- Statuts : pending, confirmed, completed, cancelled, refused

#### Review
- Champs : content, rating
- Relations : belongs_to :rental
- Validations : contenu (10-1000 caractères), note (1-5)

### Controllers

#### VehiclesController
- Actions CRUD complètes
- Filtrage et recherche
- Sécurité : seuls les propriétaires peuvent modifier leurs véhicules

#### RentalsController
- Gestion des demandes de location
- Actions spéciales : confirm, refuse, complete
- Calcul automatique des prix
- Sécurité : accès limité aux locataires et propriétaires

#### UsersController
- Affichage et modification des profils
- Sécurité : modification limitée au propriétaire du profil

#### ReviewsController
- Création et gestion des avis
- Sécurité : avis limités aux locations terminées

## Routes

```ruby
# Vehicles
resources :vehicles do
  member do
    get :my_vehicles
  end
  resources :rentals, except: [:index]
end

# Rentals
resources :rentals, only: [:index, :show, :edit, :update, :destroy] do
  member do
    patch :confirm
    patch :refuse
    patch :complete
  end
  resources :reviews, except: [:index, :show]
end

# Reviews
resources :reviews, only: [:index, :show]

# Users
resources :users, only: [:show, :edit, :update]
```

## Tests

Le projet utilise RSpec pour les tests avec une couverture complète :

### Factories (FactoryBot)
- Factories pour tous les modèles avec traits
- Données de test réalistes

### Tests de Controllers
- Tests complets pour tous les controllers
- Vérification des autorisations et sécurité
- Tests des cas d'erreur et de succès

### Tests d'Intégration
- Flux complets de l'application
- Tests de sécurité et d'autorisation

### Exécution des Tests

```bash
# Installer les dépendances
bundle install

# Exécuter la migration pour ajouter les champs manquants
rails db:migrate

# Exécuter tous les tests
bundle exec rspec

# Exécuter des tests spécifiques
bundle exec rspec spec/controllers/vehicles_controller_spec.rb
bundle exec rspec spec/requests/integration_spec.rb
```

## Configuration

### Prérequis
- Ruby 3.3.5
- Rails 7.1.5+
- PostgreSQL
- Bundler

### Installation

1. Cloner le repository
2. Installer les dépendances : `bundle install`
3. Configurer la base de données : `rails db:setup`
4. Exécuter les migrations : `rails db:migrate`
5. Lancer le serveur : `rails server`

### Variables d'Environnement

Configurer les variables suivantes pour la production :
- `DATABASE_URL` : URL de la base de données PostgreSQL
- `SECRET_KEY_BASE` : Clé secrète Rails

## Sécurité

### Authentification
- Devise pour la gestion des utilisateurs
- Sessions sécurisées

### Autorisation
- Vérifications dans tous les controllers
- Accès limité aux ressources propres à l'utilisateur
- Protection contre les modifications non autorisées

### Validations
- Validations complètes sur tous les modèles
- Protection contre les données invalides
- Vérification des chevauchements de dates

## API Endpoints

### Vehicles
- `GET /vehicles` - Liste des véhicules disponibles
- `GET /vehicles/:id` - Détails d'un véhicule
- `POST /vehicles` - Créer un véhicule
- `PATCH /vehicles/:id` - Modifier un véhicule
- `DELETE /vehicles/:id` - Supprimer un véhicule

### Rentals
- `GET /rentals` - Mes locations
- `POST /vehicles/:vehicle_id/rentals` - Créer une demande de location
- `PATCH /rentals/:id/confirm` - Confirmer une location
- `PATCH /rentals/:id/refuse` - Refuser une location
- `PATCH /rentals/:id/complete` - Marquer comme terminée

### Reviews
- `GET /reviews` - Tous les avis
- `POST /rentals/:rental_id/reviews` - Créer un avis
- `PATCH /rentals/:rental_id/reviews/:id` - Modifier un avis

### Users
- `GET /users/:id` - Profil utilisateur
- `PATCH /users/:id` - Modifier le profil

## Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## Licence

Ce projet est sous licence MIT.
