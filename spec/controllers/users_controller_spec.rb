require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET #show" do
    let!(:user_vehicle) { create(:vehicle, user: user, available: true) }
    let!(:unavailable_vehicle) { create(:vehicle, user: user, available: false) }
    let!(:completed_rental) { create(:rental, :completed, user: user) }
    let!(:user_review) { create(:review, rental: completed_rental) }

    it "assigns the requested user" do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it "assigns user's available vehicles" do
      get :show, params: { id: user.id }
      expect(assigns(:user_vehicles)).to include(user_vehicle)
      expect(assigns(:user_vehicles)).not_to include(unavailable_vehicle)
    end

    it "assigns user's reviews" do
      get :show, params: { id: user.id }
      expect(assigns(:user_reviews)).to include(user_review)
    end

    context "when viewing another user's profile" do
      it "shows the profile" do
        get :show, params: { id: other_user.id }
        expect(assigns(:user)).to eq(other_user)
        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    context "when editing own profile" do
      it "assigns the current user" do
        get :edit, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end

      it "renders the edit template" do
        get :edit, params: { id: user.id }
        expect(response).to render_template(:edit)
      end
    end

    context "when trying to edit another user's profile" do
      it "redirects to root path" do
        get :edit, params: { id: other_user.id }
        expect(response).to redirect_to(root_path)
      end

      it "shows an alert message" do
        get :edit, params: { id: other_user.id }
        expect(flash[:alert]).to eq('You can only edit your own profile.')
      end
    end
  end

  describe "PATCH #update" do
    let(:valid_attributes) do
      {
        first_name: "Jane",
        last_name: "Smith",
        age: 30,
        address: "456 Oak Street, New City, Country"
      }
    end

    context "when updating own profile" do
      context "with valid parameters" do
        it "updates the user" do
          patch :update, params: { id: user.id, user: valid_attributes }
          user.reload
          expect(user.first_name).to eq("Jane")
          expect(user.last_name).to eq("Smith")
          expect(user.age).to eq(30)
          expect(user.address).to eq("456 Oak Street, New City, Country")
        end

        it "redirects to the user profile" do
          patch :update, params: { id: user.id, user: valid_attributes }
          expect(response).to redirect_to(user)
        end

        it "shows a success message" do
          patch :update, params: { id: user.id, user: valid_attributes }
          expect(flash[:notice]).to eq('Profile was successfully updated.')
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) do
          {
            first_name: "",
            age: 15  # Below minimum age
          }
        end

        it "does not update the user" do
          original_name = user.first_name
          patch :update, params: { id: user.id, user: invalid_attributes }
          user.reload
          expect(user.first_name).to eq(original_name)
        end

        it "renders the edit template" do
          patch :update, params: { id: user.id, user: invalid_attributes }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when trying to update another user's profile" do
      it "redirects to root path" do
        patch :update, params: { id: other_user.id, user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end

      it "does not update the other user" do
        original_name = other_user.first_name
        patch :update, params: { id: other_user.id, user: valid_attributes }
        other_user.reload
        expect(other_user.first_name).to eq(original_name)
      end

      it "shows an alert message" do
        patch :update, params: { id: other_user.id, user: valid_attributes }
        expect(flash[:alert]).to eq('You can only edit your own profile.')
      end
    end
  end
end 