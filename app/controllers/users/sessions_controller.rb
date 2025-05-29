class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super do |resource|
      if resource
        # Message de succès personnalisé pour la connexion
        flash[:notice] = "🚗 Content de vous revoir ! Vous êtes maintenant connecté(e) à CARinBee."
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super do
      # Message personnalisé pour la déconnexion
      flash[:notice] = "👋 À bientôt ! Vous avez été déconnecté(e) avec succès."
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # The path used after sign in.
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # The path used after sign out.
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end 