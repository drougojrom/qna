module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def vote_for(user)
    create_vote_with_params(user, 1)
  end

  def vote_against(user)
    create_vote_with_params(user, -1)
  end

  def vote_revoke(user)
    user_vote(user).destroy
  end

  def user_vote(user)
    votes.find_or_initialize_by(user: user)
  end

  private 

  def create_vote_with_params(user, value)
    votes.create(user: user, value: value)
  end
end
