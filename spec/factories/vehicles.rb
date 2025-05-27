FactoryBot.define do
  factory :vehicle do
    association :user
    brand { "Toyota" }
    model { "Camry" }
    daily_price { 50 }
    localization { "Paris, France" }
    number_of_places { 5 }
    category { "Sedan" }
    fuel_type { "Gasoline" }
    kilometers { 50000 }
    description { "A reliable and comfortable sedan perfect for city driving." }
    available { true }
  end
end 