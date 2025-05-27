require 'rails_helper'

RSpec.describe VehiclesController, type: :controller do
  render_views false
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:vehicle) { create(:vehicle, user: user) }
  let(:other_vehicle) { create(:vehicle, user: other_user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let!(:available_vehicle) { create(:vehicle, available: true) }
    let!(:unavailable_vehicle) { create(:vehicle, available: false) }

    it "returns only available vehicles" do
      get :index
      expect(assigns(:vehicles)).to include(available_vehicle)
      expect(assigns(:vehicles)).not_to include(unavailable_vehicle)
    end

    it "filters by search term" do
      toyota = create(:vehicle, brand: "Toyota", available: true)
      honda = create(:vehicle, brand: "Honda", available: true)
      
      get :index, params: { search: "Toyota" }
      expect(assigns(:vehicles)).to include(toyota)
      expect(assigns(:vehicles)).not_to include(honda)
    end

    it "filters by category" do
      sedan = create(:vehicle, category: "Sedan", available: true)
      suv = create(:vehicle, category: "SUV", available: true)
      
      get :index, params: { category: "Sedan" }
      expect(assigns(:vehicles)).to include(sedan)
      expect(assigns(:vehicles)).not_to include(suv)
    end

    it "filters by max price" do
      cheap_car = create(:vehicle, daily_price: 30, available: true)
      expensive_car = create(:vehicle, daily_price: 100, available: true)
      
      get :index, params: { max_price: 50 }
      expect(assigns(:vehicles)).to include(cheap_car)
      expect(assigns(:vehicles)).not_to include(expensive_car)
    end
  end

  describe "GET #show" do
    it "assigns the requested vehicle" do
      get :show, params: { id: vehicle.id }
      expect(assigns(:vehicle)).to eq(vehicle)
    end

    it "assigns a new rental" do
      get :show, params: { id: vehicle.id }
      expect(assigns(:rental)).to be_a_new(Rental)
    end
  end

  describe "GET #new" do
    it "assigns a new vehicle" do
      get :new
      expect(assigns(:vehicle)).to be_a_new(Vehicle)
      expect(assigns(:vehicle).user).to eq(user)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) do
      {
        brand: "Toyota",
        model: "Camry",
        daily_price: 50,
        localization: "Paris",
        number_of_places: 5,
        category: "Sedan",
        fuel_type: "Gasoline",
        kilometers: 50000,
        description: "Great car",
        available: true
      }
    end

    context "with valid parameters" do
      it "creates a new vehicle" do
        expect {
          post :create, params: { vehicle: valid_attributes }
        }.to change(Vehicle, :count).by(1)
      end

      it "assigns the vehicle to the current user" do
        post :create, params: { vehicle: valid_attributes }
        expect(assigns(:vehicle).user).to eq(user)
      end

      it "redirects to the created vehicle" do
        post :create, params: { vehicle: valid_attributes }
        expect(response).to redirect_to(Vehicle.last)
      end
    end

    context "with invalid parameters" do
      it "does not create a new vehicle" do
        expect {
          post :create, params: { vehicle: { brand: "" } }
        }.not_to change(Vehicle, :count)
      end

      it "renders the new template" do
        post :create, params: { vehicle: { brand: "" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    context "when user owns the vehicle" do
      it "assigns the requested vehicle" do
        get :edit, params: { id: vehicle.id }
        expect(assigns(:vehicle)).to eq(vehicle)
      end
    end

    context "when user does not own the vehicle" do
      it "redirects to vehicles path" do
        get :edit, params: { id: other_vehicle.id }
        expect(response).to redirect_to(vehicles_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when user owns the vehicle" do
      context "with valid parameters" do
        it "updates the vehicle" do
          patch :update, params: { id: vehicle.id, vehicle: { brand: "Honda" } }
          vehicle.reload
          expect(vehicle.brand).to eq("Honda")
        end

        it "redirects to the vehicle" do
          patch :update, params: { id: vehicle.id, vehicle: { brand: "Honda" } }
          expect(response).to redirect_to(vehicle)
        end
      end

      context "with invalid parameters" do
        it "renders the edit template" do
          patch :update, params: { id: vehicle.id, vehicle: { brand: "" } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when user does not own the vehicle" do
      it "redirects to vehicles path" do
        patch :update, params: { id: other_vehicle.id, vehicle: { brand: "Honda" } }
        expect(response).to redirect_to(vehicles_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user owns the vehicle" do
      it "destroys the vehicle" do
        vehicle_to_delete = create(:vehicle, user: user)
        expect {
          delete :destroy, params: { id: vehicle_to_delete.id }
        }.to change(Vehicle, :count).by(-1)
      end

      it "redirects to vehicles path" do
        delete :destroy, params: { id: vehicle.id }
        expect(response).to redirect_to(vehicles_path)
      end
    end

    context "when user does not own the vehicle" do
      it "redirects to vehicles path" do
        delete :destroy, params: { id: other_vehicle.id }
        expect(response).to redirect_to(vehicles_path)
      end
    end
  end

  describe "GET #my_vehicles" do
    let!(:user_vehicle) { create(:vehicle, user: user) }
    let!(:other_user_vehicle) { create(:vehicle, user: other_user) }

    it "assigns only current user's vehicles" do
      get :my_vehicles
      expect(assigns(:vehicles)).to include(user_vehicle)
      expect(assigns(:vehicles)).not_to include(other_user_vehicle)
    end
  end
end 