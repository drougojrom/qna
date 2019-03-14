class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, numericality: { only_integer: true }
  validates :user_id, uniqueness: { scope: [:votable_id] }
end
