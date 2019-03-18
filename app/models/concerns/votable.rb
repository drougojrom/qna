module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def vote_for(user)
    votes.create(user: user, value: 1)
  end

  def vote_against(user)
    votes.create(user: user, value: -1)
  end

  def vote_revoke(user)
    user_vote(user).destroy
  end

  def user_vote(user)
    votes.find_or_initialize_by(user: user)
  end
end
