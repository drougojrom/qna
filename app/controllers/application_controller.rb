class ApplicationController < ActionController::Base

  #include Pundit

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization

  def ensure_signup_complete
    return if action_name == 'finish_signup'

    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  private

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end
end
