require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  render_views false
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:completed_rental) { create(:rental, :completed, user: user) }
  let(:pending_rental) { create(:rental, user: user) }
  let(:review) { create(:review, rental: completed_rental) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let!(:review1) { create(:review) }
    let!(:review2) { create(:review) }

    it "assigns all reviews" do
      get :index
      expect(assigns(:reviews)).to include(review1, review2)
    end

    it "orders reviews by creation date descending" do
      get :index
      reviews = assigns(:reviews)
      expect(reviews.first.created_at).to be >= reviews.last.created_at
    end
  end

  describe "GET #show" do
    it "assigns the requested review" do
      get :show, params: { id: review.id }
      expect(assigns(:review)).to eq(review)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) do
      {
        content: "Great experience! Highly recommended.",
        rating: 5
      }
    end

    context "when rental is completed and user is the renter" do
      it "creates a new review" do
        expect {
          post :create, params: { rental_id: completed_rental.id, review: valid_attributes }
        }.to change(Review, :count).by(1)
      end

      it "assigns the review to the rental" do
        post :create, params: { rental_id: completed_rental.id, review: valid_attributes }
        expect(assigns(:review).rental).to eq(completed_rental)
      end

      it "redirects to the rental" do
        post :create, params: { rental_id: completed_rental.id, review: valid_attributes }
        expect(response).to redirect_to(completed_rental)
      end

      it "shows a success message" do
        post :create, params: { rental_id: completed_rental.id, review: valid_attributes }
        expect(flash[:notice]).to eq('Review was successfully created.')
      end
    end

    context "when rental is not completed" do
      it "redirects to the rental with alert" do
        post :create, params: { rental_id: pending_rental.id, review: valid_attributes }
        expect(response).to redirect_to(pending_rental)
        expect(flash[:alert]).to eq('You can only review completed rentals.')
      end

      it "does not create a review" do
        expect {
          post :create, params: { rental_id: pending_rental.id, review: valid_attributes }
        }.not_to change(Review, :count)
      end
    end

    context "when user is not the renter" do
      let(:other_rental) { create(:rental, :completed, user: other_user) }

      it "redirects to the rental with alert" do
        post :create, params: { rental_id: other_rental.id, review: valid_attributes }
        expect(response).to redirect_to(other_rental)
        expect(flash[:alert]).to eq('You can only review completed rentals.')
      end

      it "does not create a review" do
        expect {
          post :create, params: { rental_id: other_rental.id, review: valid_attributes }
        }.not_to change(Review, :count)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          content: "Too short",  # Less than 10 characters
          rating: 6  # Out of range
        }
      end

      it "does not create a review" do
        expect {
          post :create, params: { rental_id: completed_rental.id, review: invalid_attributes }
        }.not_to change(Review, :count)
      end

      it "redirects to the rental with error message" do
        post :create, params: { rental_id: completed_rental.id, review: invalid_attributes }
        expect(response).to redirect_to(completed_rental)
        expect(flash[:alert]).to include('Error creating review:')
      end
    end
  end

  describe "GET #edit" do
    context "when user owns the review" do
      it "assigns the review" do
        get :edit, params: { id: review.id, rental_id: completed_rental.id }
        expect(assigns(:review)).to eq(review)
      end

      it "renders the edit template" do
        get :edit, params: { id: review.id, rental_id: completed_rental.id }
        expect(response).to render_template(:edit)
      end
    end

    context "when user does not own the review" do
      let(:other_rental) { create(:rental, :completed, user: other_user) }
      let(:other_review) { create(:review, rental: other_rental) }

      it "redirects to the rental with alert" do
        get :edit, params: { id: other_review.id, rental_id: other_rental.id }
        expect(response).to redirect_to(other_rental)
        expect(flash[:alert]).to eq('You can only manage your own reviews.')
      end
    end
  end

  describe "PATCH #update" do
    let(:valid_attributes) do
      {
        content: "Updated review content with more details about the experience.",
        rating: 4
      }
    end

    context "when user owns the review" do
      context "with valid parameters" do
        it "updates the review" do
          patch :update, params: { id: review.id, rental_id: completed_rental.id, review: valid_attributes }
          review.reload
          expect(review.content).to eq("Updated review content with more details about the experience.")
          expect(review.rating).to eq(4)
        end

        it "redirects to the rental" do
          patch :update, params: { id: review.id, rental_id: completed_rental.id, review: valid_attributes }
          expect(response).to redirect_to(completed_rental)
        end

        it "shows a success message" do
          patch :update, params: { id: review.id, rental_id: completed_rental.id, review: valid_attributes }
          expect(flash[:notice]).to eq('Review was successfully updated.')
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) do
          {
            content: "Short",  # Too short
            rating: 0  # Out of range
          }
        end

        it "does not update the review" do
          original_content = review.content
          patch :update, params: { id: review.id, rental_id: completed_rental.id, review: invalid_attributes }
          review.reload
          expect(review.content).to eq(original_content)
        end

        it "renders the edit template" do
          patch :update, params: { id: review.id, rental_id: completed_rental.id, review: invalid_attributes }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when user does not own the review" do
      let(:other_rental) { create(:rental, :completed, user: other_user) }
      let(:other_review) { create(:review, rental: other_rental) }

      it "redirects to the rental with alert" do
        patch :update, params: { id: other_review.id, rental_id: other_rental.id, review: valid_attributes }
        expect(response).to redirect_to(other_rental)
        expect(flash[:alert]).to eq('You can only manage your own reviews.')
      end

      it "does not update the review" do
        original_content = other_review.content
        patch :update, params: { id: other_review.id, rental_id: other_rental.id, review: valid_attributes }
        other_review.reload
        expect(other_review.content).to eq(original_content)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user owns the review" do
      it "destroys the review" do
        review_to_delete = create(:review, rental: completed_rental)
        expect {
          delete :destroy, params: { id: review_to_delete.id, rental_id: completed_rental.id }
        }.to change(Review, :count).by(-1)
      end

      it "redirects to the rental" do
        delete :destroy, params: { id: review.id, rental_id: completed_rental.id }
        expect(response).to redirect_to(completed_rental)
      end

      it "shows a success message" do
        delete :destroy, params: { id: review.id, rental_id: completed_rental.id }
        expect(flash[:notice]).to eq('Review was successfully deleted.')
      end
    end

    context "when user does not own the review" do
      let(:other_rental) { create(:rental, :completed, user: other_user) }
      let(:other_review) { create(:review, rental: other_rental) }

      it "redirects to the rental with alert" do
        delete :destroy, params: { id: other_review.id, rental_id: other_rental.id }
        expect(response).to redirect_to(other_rental)
        expect(flash[:alert]).to eq('You can only manage your own reviews.')
      end

      it "does not destroy the review" do
        other_review # Create the review
        expect {
          delete :destroy, params: { id: other_review.id, rental_id: other_rental.id }
        }.not_to change(Review, :count)
      end
    end
  end
end 