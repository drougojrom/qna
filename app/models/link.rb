require 'uri'

class Link < ApplicationRecord

  GIST_URL = "gist.github.com"

  validates :name, presence: true
  validates :url, presence: true, format: { with: URI.regexp }

  belongs_to :linkable, polymorphic: true

  def gist_link?
    self.url.include?(GIST_URL)
  end
end
