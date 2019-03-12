class Reward < ApplicationRecord
  belongs_to :question
  has_one :user

  has_one_attached :image

  validates :title, presence: true
end
