class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi"
    @titles = Question.new_question_titles.to_a.map { |question| question.title }
    mail to: user.email
  end
end
