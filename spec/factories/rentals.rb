FactoryBot.define do
  factory :rental do
    association :user
    association :vehicle
    rental_start_date { Date.current + 1.day }
    rental_end_date { Date.current + 3.days }
    total_price { 150 }
    status { "pending" }

    trait :confirmed do
      status { "confirmed" }
    end

    trait :completed do
      status { "completed" }
    end

    trait :cancelled do
      status { "cancelled" }
    end

    trait :refused do
      status { "refused" }
    end
  end
end 