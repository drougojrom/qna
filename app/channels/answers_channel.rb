class AnswersChannel < ApplicationCable::Channel
  def follow_answers
    stream_from "answers"
  end
end
