class ApplicationController < ActionController::Base

  #include Pundit

  protect_from_forgery unless: -> { request.format.json? }

  before_action :gon_user, unless: :devise_controller?

  respond_to :html, :js, :json

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: exception.message, status: :forbidden }
      format.js { render json: exception.message, status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

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
