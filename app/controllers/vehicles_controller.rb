class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @vehicles = Vehicle.where(available: true).includes(:user)
    @vehicles = @vehicles.where("brand ILIKE ? OR model ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    @vehicles = @vehicles.where(category: params[:category]) if params[:category].present?
    @vehicles = @vehicles.where("daily_price <= ?", params[:max_price]) if params[:max_price].present?
    @vehicles_for_markers = Vehicle.all
    # The `geocoded` scope filters only flats with coordinates
    @markers = @vehicles_for_markers.geocoded.map do |vehicle|
      {
        lat: vehicle.latitude,
        lng: vehicle.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {vehicle: vehicle}),
        marker_html: render_to_string(partial: "marker")
      }
    end
  end

  def show
    @rental = Rental.new
  end

  def new
    @vehicle = current_user.vehicles.build
  end

  def create
    @vehicle = current_user.vehicles.build(vehicle_params)

    if @vehicle.save
      redirect_to @vehicle, notice: 'Vehicle was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to @vehicle, notice: 'Vehicle was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to vehicles_path, notice: 'Vehicle was successfully deleted.'
  end

  def my_vehicles
    @vehicles = current_user.vehicles.includes(:rentals)
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def ensure_owner
    redirect_to vehicles_path, alert: 'You can only manage your own vehicles.' unless @vehicle.user == current_user
  end

  def vehicle_params
    params.require(:vehicle).permit(:brand, :model, :daily_price, :localization, :number_of_places,
                                   :category, :fuel_type, :kilometers, :description, :available, :image_url)
  end
end
