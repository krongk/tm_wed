class SmsSendWorker
  include Sidekiq::Worker

  def perform(mobile_phone, content)
    status_id = SmsBao.send(ENV['SMS_BAO_USER'], ENV['SMS_BAO_PASSWORD'], mobile_phone, content)
    #SitePage::Keystore.increment_value_for("sms_send:#{mobile_phone}", status_id)
  end
end