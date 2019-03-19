module ApplicationHelper
  def vote_for_btn_state(votable)
    if signed_in? && current_user != votable.user && votable.user_vote(current_user).new_record?
      'enabled'
    else
      'disabled'
    end
  end

  def vote_against_btn_state(votable)
    if signed_in? && current_user != votable.user && votable.user_vote(current_user).new_record?
      'enabled'
    else
      'disabled'
    end
  end

  def vote_revoke_btn_state(votable)
    if signed_in? && current_user != votable.user && votable.user_vote(current_user).persisted?
      'enabled'
    else
      'disabled'
    end
  end
end
