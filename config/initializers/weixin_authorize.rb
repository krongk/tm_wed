module WeixinAuthorize
  def self.client
    @@client ||= WeixinAuthorize::Client.new(ENV['APP_ID'], ENV['APP_SECRET'])
  end
end
