module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :delete_all
  end

  def make_comment(user, body)
    comments.create!(user: user, body: body)
  end
end
