class ReviewsController < ApplicationController
  before_action :set_rental, only: [:create, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :ensure_rental_completed, only: [:create]
  before_action :ensure_review_owner, only: [:edit, :update, :destroy]

  def index
    @reviews = Review.includes(:rental => [:vehicle, :user]).order(created_at: :desc)
  end

  def show
  end

  def create
    @review = @rental.reviews.build(review_params)

    if @review.save
      redirect_to @rental, notice: 'Review was successfully created.'
    else
      redirect_to @rental, alert: 'Error creating review: ' + @review.errors.full_messages.join(', ')
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to @review.rental, notice: 'Review was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    rental = @review.rental
    @review.destroy
    redirect_to rental, notice: 'Review was successfully deleted.'
  end

  private

  def set_rental
    @rental = Rental.find(params[:rental_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def ensure_rental_completed
    unless @rental.status == 'completed' && @rental.user == current_user
      redirect_to @rental, alert: 'You can only review completed rentals.'
    end
  end

  def ensure_review_owner
    unless @review.rental.user == current_user
      redirect_to @review.rental, alert: 'You can only manage your own reviews.'
    end
  end

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
