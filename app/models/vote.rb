class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :votable, presence: true
  validates :value, numericality: { only_integer: true }
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  delegate :rating, to: :votable

  after_create :cast
  before_destroy :revoke

  private

  def cast
    votable.increment! :rating, value
  end

  def revoke
    votable.decrement! :rating, value
  end
end
