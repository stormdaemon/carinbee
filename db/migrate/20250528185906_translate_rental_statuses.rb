class TranslateRentalStatuses < ActiveRecord::Migration[7.1]
  def up
    # Traduction des statuts de l'anglais vers le français
    execute "UPDATE rentals SET status = 'en_attente' WHERE status = 'pending'"
    execute "UPDATE rentals SET status = 'confirmée' WHERE status = 'confirmed'"
    execute "UPDATE rentals SET status = 'terminée' WHERE status = 'completed'"
    execute "UPDATE rentals SET status = 'annulée' WHERE status = 'cancelled'"
    execute "UPDATE rentals SET status = 'refusée' WHERE status = 'refused'"
  end

  def down
    # Retour vers l'anglais si besoin de rollback
    execute "UPDATE rentals SET status = 'pending' WHERE status = 'en_attente'"
    execute "UPDATE rentals SET status = 'confirmed' WHERE status = 'confirmée'"
    execute "UPDATE rentals SET status = 'completed' WHERE status = 'terminée'"
    execute "UPDATE rentals SET status = 'cancelled' WHERE status = 'annulée'"
    execute "UPDATE rentals SET status = 'refused' WHERE status = 'refusée'"
  end
end
