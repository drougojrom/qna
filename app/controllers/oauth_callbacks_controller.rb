class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    handle_oauth
  end

  def twitter
    handle_oauth
  end

  private 

  def handle_oauth
    @user = User.find_for_oauth(oauth_hash)
    if @user&.persisted? && @user.email_verified?
      sign_in_user(oauth_hash.provider)
    elsif @user&.persisted? && oauth_hash.provider == 'github'
      sign_in_user(oauth_hash.provider)
    elsif @user
      finish_signup_for(@user)
    else 
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def sign_in_user(provider)
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end

  def oauth_hash
    request.env['omniauth.auth'] || session[:oauth_hash]
  end

  def finish_signup_for(resource)
    redirect_to finish_signup_path(resource)
  end
end
