class Link < ApplicationRecord
  validates :name, :url, presence: true

  belongs_to :linkable, polymorphic: true
end
