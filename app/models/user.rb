class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :validatable,
    :omniauthable, omniauth_providers: [:github, :twitter]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  scope :all_except, ->(user) { where.not(id: user) }

  TEMP_EMAIL_REGEX = /\Achange@me/

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def author_of?(obj)
    id == obj.user_id
  end

  def subscribed?(question_id)
    subscription(question_id).nil?
  end

  def current_subscription(question_id)
    subscription(question_id)
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  private

  def subscription(question_id)
    subscriptions.find_by(question_id: question_id)
  end
end
