module ApplicationHelper
  def vote_for_btn_state votable
    unless signed_in? && current_user != votable.user && votable.user_vote(current_user).new_record?
      'disabled'
    end
  end

  def vote_against_btn_state votable
    unless signed_in? && current_user != votable.user && votable.user_vote(current_user).new_record?
      'disabled'
    end
  end

  def vote_revoke_btn_state votable
    unless signed_in? && current_user != votable.user && votable.user_vote(current_user).persisted?
      'disabled'
    end
  end
end
