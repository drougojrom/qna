class Reward < ApplicationRecord
  belongs_to :question
  has_one :user

  has_one_attached :image

  before_save :contains_image?

  validates :title, presence: true

  private 

  def contains_image?
    self.image.filename.to_s.include?(".png") || image.to_s.include?(".jpg")
  end
end
