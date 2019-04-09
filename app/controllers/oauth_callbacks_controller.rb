class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_user('Github')
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted? && @user.email_verified?
      sign_in_user('Twitter')
    elsif @user
      finish_signup_for(@user)
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def finish_signup_for(resource)
    redirect_to finish_signup_path(resource)
  end

  private 

  def sign_in_user(provider)
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end
end
