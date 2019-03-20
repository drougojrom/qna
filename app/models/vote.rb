class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, numericality: { only_integer: true }, inclusion: { in: [-1, 1] }
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  delegate :rating, to: :votable

  after_create :cast
  before_destroy :revoke

  def new_vote?(current_user)
    current_user&.id == user_id && new_record?
  end

  private

  def cast
    votable.increment! :rating, value
  end

  def revoke
    votable.decrement! :rating, value
  end
end
