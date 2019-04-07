class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :questions
  has_many :answers
  has_many :rewards

  def self.find_for_oauth(auth)

  end

  def author_of?(obj)
    self.id == obj.user_id
  end
end
