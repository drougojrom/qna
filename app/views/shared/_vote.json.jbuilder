@vote = @votable.reload.user_vote current_user

json.rating_id "#rating_#{@votable.class.name.downcase}_#{@votable.id}"
json.rating @votable.rating
json.vote_for_id "#vote_for_#{@votable.class.name.downcase}_#{@votable.id}"
json.vote_for signed_in? && current_user != @votable.user && @vote.new_record?
json.vote_revoke_id "#vote_revoke_#{@votable.class.name.downcase}_#{@votable.id}"
json.vote_against_id "#vote_against_#{@votable.class.name.downcase}_#{@votable.id}"
json.vote_against signed_in? && current_user != @votable.user && @vote.new_record?
