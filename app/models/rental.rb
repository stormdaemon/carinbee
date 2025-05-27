class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle

  VALID_STATUSES = %w[pending confirmed completed cancelled refused].freeze

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
      errors.add(:rental_end_date, "must be after the start date")
    end
  end

  def vehicle_must_be_available
    return if vehicle.blank?
    unless vehicle.available?
      errors.add(:vehicle, "is not available for rent")
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
      errors.add(:base, "Vehicle is already booked for the selected dates")
    end
  end
end
