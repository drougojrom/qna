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
      format.json { render json: format_json }
    end
  end

  def vote_against
    @votable.vote_against(current_user)
    set_vote(current_user)
    respond_to do |format|
      format.json { render json: format_json }
    end
  end

  def vote_revoke
    @votable.vote_revoke(current_user)
    set_vote(current_user)
    respond_to do |format|
      format.json { render json: format_json }
    end
  end

  private 

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def set_vote(current_user)
    @vote = @votable.reload.user_vote(current_user)
  end

  def format_json
    {class: @votable.class.name.downcase,
     vote_for: new_vote?,
     vote_against: new_vote?,
     vote_revoke: old_vote?,
     id: @votable.id,
     rating: @votable.rating}
  end

  def old_vote?
    signed_in? && current_user == @vote.user && @vote.persisted?
  end

  def new_vote?
    signed_in? && current_user != @votable.user && @vote.new_record?
  end
end
