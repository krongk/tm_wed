#!/usr/bin/env ruby
require 'rubygems'
require 'rest_client'

class MailSendWorker
  include Sidekiq::Worker

  def perform(email, content)
    puts "mail will send to #{email}"
    response = RestClient.post "http://sendcloud.sohu.com/webapi/mail.send.json",
      :api_user => "wedxt_com_market1",
      :api_key => "xrNxNsenH9VWIxwc",
      :from => "we@wedxt.com",
      :fromname => "维斗喜帖网",
      :to => email,
      :subject => "维斗喜帖网-应用开通提醒！",
      :html => '<html><head></head><body><p>' + content + '</p></body></html>'

    puts response.code
  end

end
