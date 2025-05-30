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
      # Calculer le nombre de jours (inclure le jour de début et de fin)
      days = (@rental.rental_end_date - @rental.rental_start_date).to_i + 1
      @rental.total_price = days * @vehicle.daily_price
    end

    if @rental.save
      redirect_to @rental, notice: 'Votre demande de location a été créée avec succès.'
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
        redirect_to @rental, notice: 'Votre demande de location a été mise à jour.'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @rental.destroy
    redirect_to vehicles_path, notice: 'Votre location a bien été annulé.'
  end

  def confirm
    @rental.update(status: 'confirmée')
    redirect_to rentals_path, notice: 'Votre location a été confirmé.'
  end

  def refuse
    @rental.update(status: 'refusée')
    redirect_to rentals_path, notice: 'Votre location a été refusé.'
  end

  def complete
    @rental.update(status: 'terminée')
    redirect_to rentals_path, notice: 'Votre location est terminé.'
  end

  def cancel
    @rental.update(status: 'annulée')
    
    respond_to do |format|
      format.html { redirect_to @rental, notice: 'Votre demande de location a été annulée.' }
      format.turbo_stream { flash.now[:notice] = 'Votre demande de location a été annulée.' }
    end
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def ensure_owner_or_renter
    unless @rental.user == current_user || @rental.vehicle.user == current_user
      redirect_to rentals_path, alert: 'Vous ne pouvez accéder qu\'à vos propres locations.'
    end
  end

  def ensure_vehicle_owner
    unless @rental.vehicle.user == current_user
      redirect_to rentals_path, alert: 'Vous ne pouvez gérer que vos propres locations.'
    end
  end

  def ensure_renter
    unless @rental.user == current_user
      redirect_to rentals_path, alert: 'Vous pouvez seulement annuler vos propres demandes de location.'
    end
  end

  def rental_params
    params.require(:rental).permit(:rental_start_date, :rental_end_date, :status, :message)
  end
end
