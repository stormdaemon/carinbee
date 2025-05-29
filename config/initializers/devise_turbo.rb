# Configuration pour améliorer la compatibilité Devise + Turbo
# Cela évite les problèmes de double soumission et assure des redirections propres

Rails.application.configure do
  # Désactiver Turbo pour les formulaires Devise par défaut
  # Cela évite les conflits et les doubles soumissions
  config.after_initialize do
    # Patch pour éviter les problèmes de double soumission avec Devise
    if defined?(Devise)
      # Configuration spéciale pour Turbo avec Devise
      Devise.setup do |config|
        # Assure que les réponses d'erreur utilisent le bon format
        config.responder.error_status = :unprocessable_entity
        config.responder.redirect_status = :see_other
      end
    end
  end
end 