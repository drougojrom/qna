@vote = @votable.reload.user_vote current_user

json.rating_id "#rating_#{@votable.class.name.downcase}_#{@votable.id}"
json.rating @votable.rating
