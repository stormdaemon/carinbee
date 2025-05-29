class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle
  has_many :reviews, dependent: :destroy

  VALID_STATUSES = %w[en_attente confirmée terminée annulée refusée].freeze

  validates :rental_start_date, presence: true
  validates :rental_end_date, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: VALID_STATUSES }

  validate :end_date_after_start_date
  validate :vehicle_must_be_available, on: :create
  validate :no_overlapping_rentals, on: :create

  private

  def end_date_after_start_date
    return if rental_end_date.blank? || rental_start_date.blank?
    if rental_end_date < rental_start_date
      errors.add(:rental_end_date, "Doit être après la date de début")
    end
  end

  def vehicle_must_be_available
    return if vehicle.blank?
    unless vehicle.available?
      errors.add(:vehicle, "N'est pas disponible pour la location")
    end
  end

  def no_overlapping_rentals
    return if vehicle.blank? || rental_start_date.blank? || rental_end_date.blank?

    overlapping = Rental.where(vehicle_id: vehicle.id)
                        .where.not(id: id)
                        .where(
                          "(rental_start_date, rental_end_date) OVERLAPS (?, ?)",
                          rental_start_date, rental_end_date
                        )
    if overlapping.exists?
      errors.add(:base, "Ce véhicule n'est pas disponible pour les dates sélectionnées")
    end
  end
end
