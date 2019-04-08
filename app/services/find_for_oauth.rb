class Services::FindForOauth

  TEMP_EMAIL_PREFIX = 'change@me'

  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info['email']
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com", 
                      password: password,
                      password_confirmation: password)
      user.skip_confirmation!
      user.save!      
      user.create_authorization(auth)
    end
    user
  end
end
