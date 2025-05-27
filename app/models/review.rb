class Review < ApplicationRecord
  belongs_to :rental

  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :rating, presence: true, numericality: { only_integer: true, in: 1..5 }
end
