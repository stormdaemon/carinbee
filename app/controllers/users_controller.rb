class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :ensure_current_user, only: [:edit, :update]

  def show
    @user_vehicles = @user.vehicles.where(available: true)
    @user_reviews = Review.joins(:rental).where(rentals: { user: @user }).includes(:rental => :vehicle)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_current_user
    unless @user == current_user
      redirect_to root_path, alert: 'Vous ne pouvez que modifier votre propre profile.'
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :age, :address, :avatar_url)
  end
end
