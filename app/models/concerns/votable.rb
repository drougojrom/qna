module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def vote_for(user)
    create_vote(user, 1)
  end

  def vote_against(user)
    create_vote(user, -1)
  end

  def votable_state(current_user)
    @vote = user_vote(current_user)
    @vote.new_vote?(current_user)
  end

  def vote_revoke(user)
    user_vote(user).destroy
  end

  def user_vote(user)
    votes.find_or_initialize_by(user: user)
  end

  private 

  def create_vote(user, value)
    votes.create!(user: user, value: value)
  end
end
