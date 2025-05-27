require 'rails_helper'

RSpec.describe "Integration", type: :request do
  let(:user) { create(:user) }
  let(:vehicle_owner) { create(:user) }
  let(:vehicle) { create(:vehicle, user: vehicle_owner) }

  before do
    sign_in user
  end

  describe "Complete rental flow" do
    it "allows a user to rent a vehicle and leave a review" do
      # User views available vehicles
      get vehicles_path
      expect(response).to be_successful
      expect(response.body).to include(vehicle.brand)

      # User views vehicle details
      get vehicle_path(vehicle)
      expect(response).to be_successful
      expect(response.body).to include(vehicle.model)

      # User creates a rental request
      rental_params = {
        rental_start_date: Date.current + 1.day,
        rental_end_date: Date.current + 3.days
      }
      
      expect {
        post vehicle_rentals_path(vehicle), params: { rental: rental_params }
      }.to change(Rental, :count).by(1)

      rental = Rental.last
      expect(rental.user).to eq(user)
      expect(rental.vehicle).to eq(vehicle)
      expect(rental.status).to eq("pending")

      # Vehicle owner confirms the rental
      sign_in vehicle_owner
      patch confirm_rental_path(rental)
      rental.reload
      expect(rental.status).to eq("confirmed")

      # Vehicle owner marks rental as completed
      patch complete_rental_path(rental)
      rental.reload
      expect(rental.status).to eq("completed")

      # User leaves a review
      sign_in user
      review_params = {
        content: "Great experience! The car was perfect for our trip.",
        rating: 5
      }

      expect {
        post rental_reviews_path(rental), params: { review: review_params }
      }.to change(Review, :count).by(1)

      review = Review.last
      expect(review.rental).to eq(rental)
      expect(review.content).to include("Great experience!")
      expect(review.rating).to eq(5)
    end
  end

  describe "Vehicle management flow" do
    it "allows a user to create and manage their vehicles" do
      # User creates a new vehicle
      vehicle_params = {
        brand: "Honda",
        model: "Civic",
        daily_price: 40,
        localization: "Lyon, France",
        number_of_places: 5,
        category: "Compact",
        fuel_type: "Gasoline",
        kilometers: 30000,
        description: "Economical and reliable car",
        available: true
      }

      expect {
        post vehicles_path, params: { vehicle: vehicle_params }
      }.to change(Vehicle, :count).by(1)

      new_vehicle = Vehicle.last
      expect(new_vehicle.user).to eq(user)
      expect(new_vehicle.brand).to eq("Honda")

      # User views their vehicles
      get my_vehicles_vehicles_path
      expect(response).to be_successful

      # User updates their vehicle
      patch vehicle_path(new_vehicle), params: { 
        vehicle: { daily_price: 45, description: "Updated description" } 
      }
      
      new_vehicle.reload
      expect(new_vehicle.daily_price).to eq(45)
      expect(new_vehicle.description).to eq("Updated description")
    end
  end

  describe "User profile management" do
    it "allows a user to view and update their profile" do
      # User views their profile
      get user_path(user)
      expect(response).to be_successful
      expect(response.body).to include(user.first_name)

      # User updates their profile
      patch user_path(user), params: {
        user: {
          first_name: "Jane",
          last_name: "Smith",
          age: 30,
          address: "New Address, City, Country"
        }
      }

      user.reload
      expect(user.first_name).to eq("Jane")
      expect(user.last_name).to eq("Smith")
      expect(user.age).to eq(30)
    end
  end

  describe "Authorization and security" do
    it "prevents users from accessing other users' resources" do
      other_user = create(:user)
      other_vehicle = create(:vehicle, user: other_user)
      other_rental = create(:rental, user: other_user)

      # Cannot edit other user's vehicle
      get edit_vehicle_path(other_vehicle)
      expect(response).to redirect_to(vehicles_path)

      # Cannot edit other user's rental
      get edit_rental_path(other_rental)
      expect(response).to redirect_to(rentals_path)

      # Cannot edit other user's profile
      get edit_user_path(other_user)
      expect(response).to redirect_to(root_path)
    end
  end
end 