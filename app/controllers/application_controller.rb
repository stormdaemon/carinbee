class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  skip_before_action :authenticate_user!, only: :home

  def home
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :age, :address, :avatar_url])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :age, :address, :avatar_url])
  end
end
