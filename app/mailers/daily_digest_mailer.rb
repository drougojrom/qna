class DailyDigestMailer < ApplicationMailer
  def digest(user, questions)
    @greeting = "Hi"

    @titles = questions.map { |question| question.title }
    mail to: user.email
  end
end
