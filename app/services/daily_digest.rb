class Services::DailyDigest
  def send_digest
    User.send_daily_digest
  end
end