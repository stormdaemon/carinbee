require 'rails_helper'

RSpec.describe RentalsController, type: :controller do
  let(:user) { create(:user) }
  let(:vehicle_owner) { create(:user) }
  let(:vehicle) { create(:vehicle, user: vehicle_owner) }
  let(:rental) { create(:rental, user: user, vehicle: vehicle) }
  let(:other_rental) { create(:rental) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let!(:user_rental) { create(:rental, user: user) }
    let!(:vehicle_rental) { create(:rental, vehicle: create(:vehicle, user: user)) }
    let!(:other_rental) { create(:rental) }

    it "assigns user's rentals" do
      get :index
      expect(assigns(:my_rentals)).to include(user_rental)
      expect(assigns(:my_rentals)).not_to include(other_rental)
    end

    it "assigns rentals for user's vehicles" do
      get :index
      expect(assigns(:vehicle_rentals)).to include(vehicle_rental)
      expect(assigns(:vehicle_rentals)).not_to include(other_rental)
    end
  end

  describe "GET #show" do
    context "when user is the renter" do
      it "assigns the rental" do
        get :show, params: { id: rental.id }
        expect(assigns(:rental)).to eq(rental)
      end

      context "when rental is completed" do
        let(:completed_rental) { create(:rental, :completed, user: user) }

        it "assigns a new review" do
          get :show, params: { id: completed_rental.id }
          expect(assigns(:review)).to be_a_new(Review)
        end
      end
    end

    context "when user is the vehicle owner" do
      before { sign_in vehicle_owner }

      it "assigns the rental" do
        get :show, params: { id: rental.id }
        expect(assigns(:rental)).to eq(rental)
      end
    end

    context "when user is neither renter nor vehicle owner" do
      let(:other_user) { create(:user) }
      before { sign_in other_user }

      it "redirects to rentals path" do
        get :show, params: { id: rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end
  end

  describe "GET #new" do
    it "assigns a new rental" do
      get :new, params: { vehicle_id: vehicle.id }
      expect(assigns(:rental)).to be_a_new(Rental)
      expect(assigns(:vehicle)).to eq(vehicle)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) do
      {
        rental_start_date: Date.current + 1.day,
        rental_end_date: Date.current + 3.days
      }
    end

    context "with valid parameters" do
      it "creates a new rental" do
        expect {
          post :create, params: { vehicle_id: vehicle.id, rental: valid_attributes }
        }.to change(Rental, :count).by(1)
      end

      it "assigns the rental to the current user" do
        post :create, params: { vehicle_id: vehicle.id, rental: valid_attributes }
        expect(assigns(:rental).user).to eq(user)
      end

      it "assigns the vehicle to the rental" do
        post :create, params: { vehicle_id: vehicle.id, rental: valid_attributes }
        expect(assigns(:rental).vehicle).to eq(vehicle)
      end

      it "sets status to pending" do
        post :create, params: { vehicle_id: vehicle.id, rental: valid_attributes }
        expect(assigns(:rental).status).to eq("pending")
      end

      it "calculates total price" do
        post :create, params: { vehicle_id: vehicle.id, rental: valid_attributes }
        expected_price = 3 * vehicle.daily_price # 3 days
        expect(assigns(:rental).total_price).to eq(expected_price)
      end

      it "redirects to the created rental" do
        post :create, params: { vehicle_id: vehicle.id, rental: valid_attributes }
        expect(response).to redirect_to(Rental.last)
      end
    end

    context "with invalid parameters" do
      it "does not create a new rental" do
        expect {
          post :create, params: { vehicle_id: vehicle.id, rental: { rental_start_date: "" } }
        }.not_to change(Rental, :count)
      end

      it "renders the new template" do
        post :create, params: { vehicle_id: vehicle.id, rental: { rental_start_date: "" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    context "when user is the renter" do
      it "assigns the rental" do
        get :edit, params: { id: rental.id }
        expect(assigns(:rental)).to eq(rental)
      end
    end

    context "when user is not authorized" do
      it "redirects to rentals path" do
        get :edit, params: { id: other_rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when user is the renter" do
      context "with valid parameters" do
        it "updates the rental" do
          new_end_date = Date.current + 5.days
          patch :update, params: { id: rental.id, rental: { rental_end_date: new_end_date } }
          rental.reload
          expect(rental.rental_end_date).to eq(new_end_date)
        end

        it "redirects to the rental" do
          patch :update, params: { id: rental.id, rental: { rental_end_date: Date.current + 5.days } }
          expect(response).to redirect_to(rental)
        end
      end

      context "with invalid parameters" do
        it "renders the edit template" do
          patch :update, params: { id: rental.id, rental: { rental_start_date: "" } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when user is not authorized" do
      it "redirects to rentals path" do
        patch :update, params: { id: other_rental.id, rental: { rental_end_date: Date.current + 5.days } }
        expect(response).to redirect_to(rentals_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is the renter" do
      it "destroys the rental" do
        rental_to_delete = create(:rental, user: user)
        expect {
          delete :destroy, params: { id: rental_to_delete.id }
        }.to change(Rental, :count).by(-1)
      end

      it "redirects to rentals path" do
        delete :destroy, params: { id: rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end

    context "when user is not authorized" do
      it "redirects to rentals path" do
        delete :destroy, params: { id: other_rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end
  end

  describe "PATCH #confirm" do
    context "when user is the vehicle owner" do
      before { sign_in vehicle_owner }

      it "updates rental status to confirmed" do
        patch :confirm, params: { id: rental.id }
        rental.reload
        expect(rental.status).to eq("confirmed")
      end

      it "redirects to rentals path" do
        patch :confirm, params: { id: rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end

    context "when user is not the vehicle owner" do
      it "redirects to rentals path" do
        patch :confirm, params: { id: rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end
  end

  describe "PATCH #refuse" do
    context "when user is the vehicle owner" do
      before { sign_in vehicle_owner }

      it "updates rental status to refused" do
        patch :refuse, params: { id: rental.id }
        rental.reload
        expect(rental.status).to eq("refused")
      end

      it "redirects to rentals path" do
        patch :refuse, params: { id: rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end

    context "when user is not the vehicle owner" do
      it "redirects to rentals path" do
        patch :refuse, params: { id: rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end
  end

  describe "PATCH #complete" do
    context "when user is the vehicle owner" do
      before { sign_in vehicle_owner }

      it "updates rental status to completed" do
        patch :complete, params: { id: rental.id }
        rental.reload
        expect(rental.status).to eq("completed")
      end

      it "redirects to rentals path" do
        patch :complete, params: { id: rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end

    context "when user is not the vehicle owner" do
      it "redirects to rentals path" do
        patch :complete, params: { id: rental.id }
        expect(response).to redirect_to(rentals_path)
      end
    end
  end
end 