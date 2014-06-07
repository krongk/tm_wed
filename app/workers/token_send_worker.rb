class TokenSendWorker
  include Sidekiq::Worker

  def perform(mobile_phone, token)
    content = "登录验证码#{token}，请在10分钟内登录网站验证【维斗喜帖】"
    status_id = SmsBao.send(ENV['SMS_BAO_USER'], ENV['SMS_BAO_PASSWORD'], mobile_phone, content)
    #SitePage::Keystore.increment_value_for("sms_send:#{mobile_phone}", status_id)
  end
end