class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :validatable,
    :omniauthable, omniauth_providers: [:github, :twitter]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :authorizations, dependent: :destroy

  TEMP_EMAIL_REGEX = /\Achange@me/ 

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def author_of?(obj)
    self.id == obj.user_id
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)      
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
