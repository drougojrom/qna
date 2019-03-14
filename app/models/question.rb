class Question < ApplicationRecord

  include Votable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy

  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank  

  belongs_to :user

  validates :title, :body, presence: true

  def right_answer
    self.answers.correct_answers.first
  end
end
