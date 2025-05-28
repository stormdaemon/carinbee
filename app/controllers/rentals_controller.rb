class RentalsController < ApplicationController
  before_action :set_rental, only: [:show, :edit, :update, :destroy, :confirm, :refuse, :complete, :cancel]
  before_action :ensure_owner_or_renter, only: [:show, :edit, :update, :destroy, :cancel]
  before_action :ensure_vehicle_owner, only: [:confirm, :refuse, :complete]
  before_action :ensure_renter, only: [:cancel]

  def index
    @my_rentals = current_user.rentals.includes(:vehicle, :user).order(created_at: :desc)
    @vehicle_rentals = Rental.joins(:vehicle).where(vehicles: { user: current_user }).includes(:vehicle, :user).order(created_at: :desc)
  end

  def show
    @review = @rental.reviews.build if @rental.status == 'terminée' && @rental.user == current_user
  end

  def new
    @vehicle = Vehicle.find(params[:vehicle_id])
    @rental = current_user.rentals.build
  end

  def create
    @vehicle = Vehicle.find(params[:vehicle_id])
    @rental = current_user.rentals.build(rental_params)
    @rental.vehicle = @vehicle
    @rental.status = 'en_attente'

    # Calculate total price
    if @rental.rental_start_date && @rental.rental_end_date
      days = (@rental.rental_end_date - @rental.rental_start_date).to_i + 1
      @rental.total_price = days * @vehicle.daily_price
    end

    if @rental.save
      redirect_to @rental, notice: 'Rental request was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @rental.update(rental_params)
      if params[:rental][:status] == 'annulée'
        redirect_to vehicles_path, notice: 'Votre demande de location a été annulée.'
      else
        redirect_to @rental, notice: 'Rental was successfully updated.'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @rental.destroy
    redirect_to vehicles_path, notice: 'Rental was successfully cancelled.'
  end

  def confirm
    @rental.update(status: 'confirmée')
    redirect_to rentals_path, notice: 'Rental was confirmed.'
  end

  def refuse
    @rental.update(status: 'refusée')
    redirect_to rentals_path, notice: 'Rental was refused.'
  end

  def complete
    @rental.update(status: 'terminée')
    redirect_to rentals_path, notice: 'Rental was marked as completed.'
  end

  def cancel
    @rental.update(status: 'annulée')
    redirect_to vehicles_path, notice: 'Votre demande de location a été annulée.'
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def ensure_owner_or_renter
    unless @rental.user == current_user || @rental.vehicle.user == current_user
      redirect_to rentals_path, alert: 'You can only access your own rentals.'
    end
  end

  def ensure_vehicle_owner
    unless @rental.vehicle.user == current_user
      redirect_to rentals_path, alert: 'You can only manage rentals for your own vehicles.'
    end
  end

  def ensure_renter
    unless @rental.user == current_user
      redirect_to rentals_path, alert: 'You can only cancel your own rental requests.'
    end
  end

  def rental_params
    params.require(:rental).permit(:rental_start_date, :rental_end_date, :status)
  end
end
