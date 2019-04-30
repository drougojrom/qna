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
  after_save :add_subscription, on: :create

  scope :new_question_titles, -> { where(created_at: 24.hours.ago..Time.now) }

  def right_answer
    answers.correct_answers.first
  end

  def add_subscription(current_user = nil)
    user_id ||= current_user ? current_user.id : user.id
    subscriptions.create!(user_id: user_id)
  end

  def remove_subscription(user)
    subscriptions.where(user: user).first.destroy
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
