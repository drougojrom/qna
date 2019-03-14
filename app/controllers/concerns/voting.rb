module Voting
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_for, :vote_against, :vote_revoke]
    respond_to :json
  end

  def vote_for
    if @votable.vote_for(current_user)
      render partial: 'shared/vote'
    end
  end

  def vote_against
    respond_with @votable.vote_against(current_user) do |format|
      format.json { render partial: 'shared/vote' }
    end
  end

  def vote_revoke
    respond_with @votable.vote_revoke(current_user) do |format| 
      format.json { render partial: 'shared/vote' }
    end
  end

  private 

  def set_votable
    @votable = controller_name.classify.constantize.find params[:id]
  end
end
