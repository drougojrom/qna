module Voting
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_for, :vote_against, :vote_revoke]
    respond_to :json
  end

  def vote_for
    @votable.vote_for(current_user)
    render partial: 'shared/vote'
  end

  def vote_against
    @votable.vote_against(current_user)
    render partial: 'shared/vote'
  end

  def vote_revoke
    @votable.vote_revoke(current_user)
    render partial: 'shared/vote'
  end

  private 

  def set_votable
    @votable = controller_name.classify.constantize.find params[:id]
  end
end
