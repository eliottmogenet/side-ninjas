class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  after_action :store_history
  include Pundit

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :batch_number, :city, :pays, :bootcamp_year, :github_username, :linkedin_username, :slack_username, :photo])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :batch_number, :city, :pays, :bootcamp_year, :github_username, :linkedin_username, :slack_username, :photo])

    # For additional in app/views/devise/registrations/edit.html.erb
  end

  private

  def store_history
    return unless request.get?
    return if request.xhr?
    session[:history] ||= []
    session[:history] << request.fullpath
    session[:history].delete_at 0 if session[:history].size == 6
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
end
