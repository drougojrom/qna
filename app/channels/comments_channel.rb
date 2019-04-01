class CommentsChannel < ApplicationCable::Channel
  def follow_comments
    stream_from "comments"
  end
end
