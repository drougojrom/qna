class CommentsChannel < ApplicationCable::Channel
  def follow_comments(data)
    stream_from "comments_for_#{data['id']}" 
  end
end
