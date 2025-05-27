FactoryBot.define do
  factory :review do
    association :rental
    content { "Great experience! The car was clean and comfortable. Highly recommended." }
    rating { 5 }

    trait :poor_rating do
      content { "Not satisfied with the service. The car had some issues." }
      rating { 2 }
    end

    trait :average_rating do
      content { "Decent experience. Nothing special but got the job done." }
      rating { 3 }
    end
  end
end 