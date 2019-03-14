module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def vote_for
    votes.create(user: current_user, value: 1)
  end

  def vote_against
    votes.create(user: current_user, value: -1)
  end

  def vote_revoke
    vote.destroy if vote.persisted?
  end

  private

  def vote
    votes.find_by(user: current_user)
  end
end
