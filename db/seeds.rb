require 'faker'
require 'open-uri'

puts "🌱 Cleaning database..."
Rental.destroy_all
Review.destroy_all
Vehicle.destroy_all
User.destroy_all
puts "✅ Database cleaned."

puts "\n👤 Creating users..."
user_refs = [
  "Alex - du76", "Amandine - du38", "Morgane - Makeup", "Sylvain - Durif", "Bruno - JeanJacques",
  "Bob - L'éponge", "Hans - Varchar", "Variable - Undefined", "Sophie - Python", "Marc - CSS",
  "Julie - Binaire", "Nico - Tagada", "Léa - Loop", "Charly - Cache", "Zoé - Syntax"
]

users = user_refs.map do |ref|
  first, last = ref.split(" - ")
  user = User.create!(
    first_name: first,
    last_name: last,
    age: rand(20..60),
    address: Faker::Address.full_address,
    email: Faker::Internet.unique.email,
    password: "password"
  )
  puts "👤 Created user: #{user.first_name} #{user.last_name}"
  user
end

puts "\n🚗 Creating vehicles..."

vehicle_data = [
  ["Mercedes", "Vito", "Monospace", "Diesel", 80000, "Paris", 90, 8, "https://i.postimg.cc/pVjTkzw1/Monospace-Mercedes-Vito.jpg"],
  ["Chrysler", "Pacifica", "Monospace", "Essence", 60000, "Lyon", 85, 7, "https://i.postimg.cc/Hs2TP2B3/Monospace-Chrysler-Pacifica.png"],
  ["Citroën", "Grand C4", "Monospace", "Diesel", 70000, "Marseille", 80, 7, "https://i.postimg.cc/FHzXCQfs/Monospace-Citroen-Grand-C4.avif"],
  ["Ford", "Galaxy", "Monospace", "Diesel", 65000, "Bordeaux", 75, 7, "https://i.postimg.cc/yYNGsy7L/Monospace-Ford-Galaxy.avif"],
  ["Renault", "Espace", "Monospace", "Essence", 60000, "Toulouse", 70, 7, "https://i.postimg.cc/QMc406qd/Monospace-Renault-Espace.png"],
  ["BMW", "iX3", "Confort", "Électrique", 40000, "Nice", 110, 5, "https://i.postimg.cc/YSX3XJWk/Confort-BMW-i-X3.avif"],
  ["Ford", "Kuga", "Confort", "Hybride", 50000, "Nantes", 100, 5, "https://i.postimg.cc/qRP2S0Mf/Confort-Ford-Kuga.avif"],
  ["Mercedes", "EQC", "Confort", "Électrique", 30000, "Lille", 130, 5, "https://i.postimg.cc/MTQQy409/Confort-Mercedes-EQC.avif"],
  ["Volvo", "XC60", "Confort", "Hybride", 45000, "Rennes", 120, 5, "https://i.postimg.cc/v871b50x/Confort-Volvo-XC60.avif"],
  ["Peugeot", "5008", "Confort", "Diesel", 55000, "Grenoble", 95, 7, "https://i.postimg.cc/Cx25m7xX/Confort-Peugeot-5008.png"],
  ["Peugeot", "e-208", "Eco", "Électrique", 25000, "Dijon", 60, 5, "https://i.postimg.cc/ZnDz4f2h/Eco-Peugeot-e-208.avif"],
  ["Hyundai", "Ioniq", "Eco", "Électrique", 30000, "Rouen", 65, 5, "https://i.postimg.cc/SNwHdzpV/Eco-Hyundai-Ionic.avif"],
  ["Fiat", "500", "Eco", "Électrique", 20000, "Orléans", 50, 4, "https://i.postimg.cc/pr3cs33y/Eco-Fiat-500.avif"],
  ["Renault", "R5", "Eco", "Électrique", 10000, "Strasbourg", 55, 4, "https://i.postimg.cc/FKhWCyCb/Eco-Renault-R5.jpg"],
  ["Renault", "Twingo", "Eco", "Électrique", 15000, "Tours", 45, 4, "https://i.postimg.cc/5tPhwK9Q/Eco-Renault-Twingo.png"]
]

descriptions = [
  "Alex l'a pimpé pour les virées sur l'A13 en mode Jacky Tuning.",
  "Amandine l'utilise pour livrer des cupcakes dans tout le 38.",
  "Morgane y stocke ses palettes de maquillage, et parfois un chien.",
  "Sylvain dit que ce véhicule 'respire le raisin et la passion'.",
  "Bruno y joue ses morceaux de flûte traversière entre deux péages.",
  "Bob a voulu faire un véhicule amphibie. Ça n'a pas marché. Mais il roule encore.",
  "Hans a codé l'interface de bord en SQL. Il faut taper une requête pour démarrer.",
  "Variable oublie souvent où il a garé la voiture. C'est pour ça qu'il la loue.",
  "Sophie dit que ce véhicule 'compile' bien les virages.",
  "Marc a redécoré l'intérieur uniquement avec Flexbox et marges auto.",
  "Julie l'appelle 'Byte-Mobile' : silencieuse, rapide, et mystérieuse.",
  "Nico a collé des bonbons sous tous les sièges. Une surprise à chaque coin.",
  "Léa a programmé le GPS pour qu'il évite les boucles infinies.",
  "Charly dit qu'il efface le cache… mais seulement en montagne.",
  "Zoé a remplacé l'autoradio par un interpréteur Ruby. Zen, non ?"
]

vehicles = vehicle_data.each_with_index.map do |(brand, model, category, fuel, km, loc, price, seats, img_url), i|
  vehicle = Vehicle.new(
    brand: brand,
    model: model,
    category: category,
    fuel_type: fuel,
    kilometers: km,
    localization: loc,
    daily_price: price,
    number_of_places: seats,
    description: descriptions[i],
    available: true,
    user: users[i]
  )

  puts "📸 Attaching image to #{brand} #{model}..."
  image_file = URI.open(img_url)
  vehicle.photo.attach(io: image_file, filename: "#{brand}_#{model}.jpg", content_type: 'image/jpg')

  vehicle.save!
  puts "🚗 Created vehicle: #{brand} #{model} (ID: #{vehicle.id})"
  vehicle
end

puts "Adding avatars to databse"

Avatar.create!([
  { url: "https://res.cloudinary.com/dmxqi2wpl/image/upload/v1748594512/femme_abeille_manga_pbk3kk.png" },
  { url: "https://res.cloudinary.com/dmxqi2wpl/image/upload/v1748594478/femme_abeille_brune_manga_yyu7n9.png" },
  { url: "https://res.cloudinary.com/dmxqi2wpl/image/upload/v1748594507/homme_abeille_manga_eyzjp4.png" },
  { url: "https://res.cloudinary.com/dmxqi2wpl/image/upload/v1748594491/homme_abeille_brun_manga.png_ggvgxo.png" }
])

puts "Avatar online"



puts "\n✅ Done seeding!"
puts "👤 Users: #{User.count}"
puts "🚗 Vehicles: #{Vehicle.count}"
puts "📝 Avatars: #{Avatar.count}"
