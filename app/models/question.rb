class Question < ApplicationRecord

  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy

  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank  

  belongs_to :user

  validates :title, :body, presence: true

  after_save :calculate_reputation, on: :create

  def self.new_question_titles
    Question.where(created_at: (Time.now - 24.hours)..Time.now)
  end

  def right_answer
    self.answers.correct_answers.first
  end

  def add_subscription(user)
    Subscription.create!(question_id: self.id, user_id: user.id)
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
