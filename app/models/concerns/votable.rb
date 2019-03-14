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

  def vote_revoke
    vote.destroy if vote.persisted?
  end

  private

  def vote(user)
    votes.find_by(user: user)
  end
end
