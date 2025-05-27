puts "Cleaning database..."
Vehicle.destroy_all

puts "Creating vehicles..."

vehicles = [
  {
    brand: "Mercedes",
    model: "Vito",
    category: "Monospace",
    daily_price: 90,
    number_of_places: 8,
    fuel_type: "Diesel",
    kilometers: 80000,
    localization: "Paris",
    available: true,
    image_url: "https://i.postimg.cc/pVjTkzw1/Monospace-Mercedes-Vito.jpg"
  },
  {
    brand: "Chrysler",
    model: "Pacifica",
    category: "Monospace",
    daily_price: 85,
    number_of_places: 7,
    fuel_type: "Essence",
    kilometers: 60000,
    localization: "Lyon",
    available: true,
    image_url: "https://i.postimg.cc/Hs2TP2B3/Monospace-Chrysler-Pacifica.png"
  },
  {
    brand: "Citroën",
    model: "Grand C4",
    category: "Monospace",
    daily_price: 80,
    number_of_places: 7,
    fuel_type: "Diesel",
    kilometers: 70000,
    localization: "Marseille",
    available: true,
    image_url: "https://i.postimg.cc/FHzXCQfs/Monospace-Citroen-Grand-C4.avif"
  },
  {
    brand: "Ford",
    model: "Galaxy",
    category: "Monospace",
    daily_price: 75,
    number_of_places: 7,
    fuel_type: "Diesel",
    kilometers: 65000,
    localization: "Bordeaux",
    available: false,
    image_url: "https://i.postimg.cc/yYNGsy7L/Monospace-Ford-Galaxy.avif"
  },
  {
    brand: "Renault",
    model: "Espace",
    category: "Monospace",
    daily_price: 70,
    number_of_places: 7,
    fuel_type: "Essence",
    kilometers: 60000,
    localization: "Toulouse",
    available: true,
    image_url: "https://i.postimg.cc/QMc406qd/Monospace-Renault-Espace.png"
  },
  {
    brand: "BMW",
    model: "iX3",
    category: "Confort",
    daily_price: 110,
    number_of_places: 5,
    fuel_type: "Électrique",
    kilometers: 40000,
    localization: "Nice",
    available: true,
    image_url: "https://i.postimg.cc/YSX3XJWk/Confort-BMW-i-X3.avif"
  },
  {
    brand: "Ford",
    model: "Kuga",
    category: "Confort",
    daily_price: 100,
    number_of_places: 5,
    fuel_type: "Hybride",
    kilometers: 50000,
    localization: "Nantes",
    available: false,
    image_url: "https://i.postimg.cc/qRP2S0Mf/Confort-Ford-Kuga.avif"
  },
  {
    brand: "Mercedes",
    model: "EQC",
    category: "Confort",
    daily_price: 130,
    number_of_places: 5,
    fuel_type: "Électrique",
    kilometers: 30000,
    localization: "Lille",
    available: true,
    image_url: "https://i.postimg.cc/MTQQy409/Confort-Mercedes-EQC.avif"
  },
  {
    brand: "Volvo",
    model: "XC60",
    category: "Confort",
    daily_price: 120,
    number_of_places: 5,
    fuel_type: "Hybride",
    kilometers: 45000,
    localization: "Rennes",
    available: true,
    image_url: "https://i.postimg.cc/v871b50x/Confort-Volvo-XC60.avif"
  },
  {
    brand: "Peugeot",
    model: "5008",
    category: "Confort",
    daily_price: 95,
    number_of_places: 7,
    fuel_type: "Diesel",
    kilometers: 55000,
    localization: "Grenoble",
    available: true,
    image_url: "https://i.postimg.cc/Cx25m7xX/Confort-Peugeot-5008.png"
  },
  {
    brand: "Peugeot",
    model: "e-208",
    category: "Eco",
    daily_price: 60,
    number_of_places: 5,
    fuel_type: "Électrique",
    kilometers: 25000,
    localization: "Dijon",
    available: true,
    image_url: "https://i.postimg.cc/ZnDz4f2h/Eco-Peugeot-e-208.avif"
  },
  {
    brand: "Hyundai",
    model: "Ioniq",
    category: "Eco",
    daily_price: 65,
    number_of_places: 5,
    fuel_type: "Électrique",
    kilometers: 30000,
    localization: "Rouen",
    available: false,
    image_url: "https://i.postimg.cc/SNwHdzpV/Eco-Hyundai-Ionic.avif"
  },
  {
    brand: "Fiat",
    model: "500",
    category: "Eco",
    daily_price: 50,
    number_of_places: 4,
    fuel_type: "Électrique",
    kilometers: 20000,
    localization: "Orléans",
    available: true,
    image_url: "https://i.postimg.cc/pr3cs33y/Eco-Fiat-500.avif"
  },
  {
    brand: "Renault",
    model: "R5",
    category: "Eco",
    daily_price: 55,
    number_of_places: 4,
    fuel_type: "Électrique",
    kilometers: 10000,
    localization: "Strasbourg",
    available: true,
    image_url: "https://i.postimg.cc/FKhWCyCb/Eco-Renault-R5.jpg"
  },
  {
    brand: "Renault",
    model: "Twingo",
    category: "Eco",
    daily_price: 45,
    number_of_places: 4,
    fuel_type: "Électrique",
    kilometers: 15000,
    localization: "Tours",
    available: true,
    image_url: "https://i.postimg.cc/5tPhwK9Q/Eco-Renault-Twingo.png"
  }
]

# Tu peux remplacer User.first ou l'associer à un user spécifique si besoin
vehicles.each do |v|
  Vehicle.create!(v.merge(user: User.first))
end

puts "✅ #{Vehicle.count} vehicles created!"
