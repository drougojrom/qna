class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def right_answer
    self.answers.where("right_answer = ?", true).first
  end
end
