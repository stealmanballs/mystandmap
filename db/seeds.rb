# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command.

puts "Seeding database..."

# Create admin user
admin = User.find_or_create_by!(email: 'admin@mystandmap.com') do |user|
  user.name = 'Admin User'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = 'admin'
end
puts "Created admin user: #{admin.email}"

# Create farmer user
farmer = User.find_or_create_by!(email: 'farmer@example.com') do |user|
  user.name = 'Demo Farmer'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = 'farmer'
end
puts "Created farmer user: #{farmer.email}"

# Create regular user
user = User.find_or_create_by!(email: 'user@example.com') do |u|
  u.name = 'Demo User'
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.role = 'user'
end
puts "Created regular user: #{user.email}"

# Sample Wisconsin farm stands
stands_data = [
  {
    name: 'Sunny Acres Farm',
    stand_type: 'farm_stand',
    city: 'Madison',
    state: 'WI',
    zip: '53703',
    address_1: '1234 Farm Road',
    latitude: 43.0731,
    longitude: -89.4012,
    products_text: 'Fresh eggs, organic vegetables, honey, maple syrup',
    hours_text: 'Mon-Sat: 8am-6pm, Sun: 10am-4pm',
    description: 'Family-owned farm since 1950. We specialize in seasonal produce and local honey.',
    verified: true,
    claimed: true
  },
  {
    name: 'Berry Good Farm',
    stand_type: 'u_pick',
    city: 'Milwaukee',
    state: 'WI',
    zip: '53202',
    address_1: '5678 Berry Lane',
    latitude: 43.0389,
    longitude: -87.9065,
    products_text: 'Strawberries, blueberries, raspberries, pumpkins',
    hours_text: 'Daily: 9am-5pm (seasonal)',
    description: 'U-pick berries and pumpkins. Bring the family for a day of fun!',
    verified: true,
    claimed: false
  },
  {
    name: 'Wisconsin Farmers Market',
    stand_type: 'farmers_market',
    city: 'Madison',
    state: 'WI',
    zip: '53703',
    address_1: 'Capitol Square',
    latitude: 43.0748,
    longitude: -89.3842,
    products_text: 'Local produce, artisan goods, baked items, crafts',
    hours_text: 'Saturday: 7am-1pm (April-October)',
    description: 'Weekly farmers market featuring local Wisconsin growers and artisans.',
    verified: true,
    claimed: true
  },
  {
    name: 'Green Valley Orchard',
    stand_type: 'roadside_stand',
    city: 'Green Bay',
    state: 'WI',
    zip: '54302',
    address_1: '9012 Orchard Way',
    latitude: 44.5133,
    longitude: -88.0133,
    products_text: 'Apples, cider, pumpkins, fall vegetables',
    hours_text: 'Daily: 10am-6pm (Sept-Nov)',
    description: 'Seasonal roadside stand with apples and cider from our orchard.',
    verified: false,
    claimed: false
  },
  {
    name: 'Happy Hen Homestead',
    stand_type: 'farm_stand',
    city: 'Appleton',
    state: 'WI',
    zip: '54911',
    address_1: '3456 Country Road',
    latitude: 44.2619,
    longitude: -88.4154,
    products_text: 'Free-range eggs, chicken, duck eggs, herbs',
    hours_text: 'By appointment',
    description: 'Small family farm specializing in heritage breed chickens and eggs.',
    verified: true,
    claimed: false
  },
  {
    name: 'Maple Ridge Sugar Bush',
    stand_type: 'farm_stand',
    city: 'Wausau',
    state: 'WI',
    zip: '54401',
    address_1: '7890 Maple Drive',
    latitude: 44.9591,
    longitude: -89.6301,
    products_text: 'Pure maple syrup, maple sugar, maple candy',
    hours_text: 'Sat-Sun: 9am-4pm (March-April)',
    description: 'Traditional maple syrup producer. Tours available during sugaring season.',
    verified: true,
    claimed: false
  },
  {
    name: 'Rolling Hills Farm',
    stand_type: 'farm_stand',
    city: 'La Crosse',
    state: 'WI',
    zip: '54601',
    address_1: '2345 Hillside Ave',
    latitude: 43.8133,
    longitude: -91.2268,
    products_text: 'Beef, pork, lamb, poultry',
    hours_text: 'Call for hours',
    description: 'Pasture-raised meats from our family farm.',
    verified: false,
    claimed: false
  },
  {
    name: "Grandma's Garden",
    stand_type: 'roadside_stand',
    city: 'Eau Claire',
    state: 'WI',
    zip: '54701',
    address_1: '567 Garden Street',
    latitude: 44.8114,
    longitude: -91.4985,
    products_text: 'Fresh vegetables, flowers, herbs',
    hours_text: 'Mon-Sat: 7am-7pm',
    description: 'Roadside stand with fresh garden vegetables.',
    verified: false,
    claimed: false
  },
  {
    name: 'River Falls Creamery',
    stand_type: 'farm_stand',
    city: 'River Falls',
    state: 'WI',
    zip: '54022',
    address_1: '8901 Dairy Lane',
    latitude: 44.8614,
    longitude: -92.6268,
    products_text: 'Raw milk, cheese, butter, yogurt',
    hours_text: 'Fri-Sun: 10am-4pm',
    description: 'Artisan dairy products from grass-fed cows.',
    verified: true,
    claimed: false
  },
  {
    name: 'Dairyland U-Pick',
    stand_type: 'u_pick',
    city: 'Janesville',
    state: 'WI',
    zip: '53545',
    address_1: '4321 Farm Road',
    latitude: 42.6828,
    longitude: -89.0187,
    products_text: 'Strawberries, sweet corn, tomatoes',
    hours_text: 'Daily: 8am-6pm (June-Sept)',
    description: 'Family-friendly u-pick farm with seasonal produce.',
    verified: false,
    claimed: false
  }
]

stands_data.each do |stand_attrs|
  stand = Stand.find_or_create_by!(name: stand_attrs[:name], city: stand_attrs[:city]) do |s|
    s.assign_attributes(stand_attrs)
    s.slug = s.name.to_s.parameterize
  end
  puts "Created stand: #{stand.name} (#{stand.city})"
end

puts "Seeding complete!"
puts ""
puts "Test accounts:"
puts "  Admin: admin@mystandmap.com / password123"
puts "  Farmer: farmer@example.com / password123"
puts "  User: user@example.com / password123"
