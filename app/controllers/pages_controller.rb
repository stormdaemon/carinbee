class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @featured_vehicles = Vehicle.where(available: true).limit(6)
    # groupby vehicle categories
    @vehicles = Vehicle.all
    @vehicles_group_by = @vehicles.group_by(&:category)
    @vehicles_group_by = @vehicles_group_by.sort_by { |category, vehicles| category }
    @vehicles_group_by = @vehicles_group_by.first(3)
  end
end
