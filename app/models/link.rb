class Link < ApplicationRecord
  validates :name, :url, presence: true

  belongs_to :question
end
