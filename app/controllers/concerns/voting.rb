module Voting
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_for, :vote_against, :vote_revoke]
    respond_to :json
  end

  def vote_for
    @votable.vote_for(current_user)
    set_vote(current_user)
    respond_to do |format|
      format.json { render json: format_json(@votable, "vote_for") }
    end
  end

  def vote_against
    @votable.vote_against(current_user)
    set_vote(current_user)
    respond_to do |format|
      format.json { render json: format_json(@votable, "vote_against") }
    end
  end

  def vote_revoke
    @votable.vote_revoke(current_user)
    set_vote(current_user)
    respond_to do |format|
      format.json { render json: format_json(@votable, "vote_revoke") }
    end
  end

  private 

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def set_vote(current_user)
    @vote = @votable.reload.user_vote(current_user)
  end

  def format_json(votable, vote_type)
    {class: @votable.class.name.downcase,
     vote_for: signed_in? && current_user != @votable.user && @vote.new_record?,
     vote_against: signed_in? && current_user != @votable.user && @vote.new_record?,
     vote_revoke: signed_in? && current_user == @vote.user && @vote.persisted?,
     id: @votable.id,
     rating: @votable.rating}
  end
end
