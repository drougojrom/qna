class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :commentable, polymorphic: true, optional: true, touch: true
  belongs_to :user
end
