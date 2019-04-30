class Services::DailyDigest
  def send_digest
    User.find_each.each do |user|
      DailyDigestMailer.digest(user, Question.new_question_titles.to_a).deliver_later
    end
  end
end