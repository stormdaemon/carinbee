class Vehicle < ApplicationRecord
  belongs_to :user
  has_many :rentals, dependent: :destroy

  validates :brand, presence: true
  validates :model, presence: true
  validates :daily_price, presence: true, numericality: { greater_than: 0 }
  validates :localization, presence: true
  validates :number_of_places, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :category, presence: true
  validates :fuel_type, presence: true
  validates :kilometers, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :available, inclusion: { in: [true, false] }
end
