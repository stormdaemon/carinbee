class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @featured_vehicles = Vehicle.where(available: true).limit(6)
  end
end
