#!/usr/bin/env ruby
require 'rubygems'
require 'rest_client'

class MailSendWorker
  include Sidekiq::Worker

  def perform(email, content)
    response = RestClient.post "http://sendcloud.sohu.com/webapi/mail.send.json",
    :api_user => "inruby_test_9oDvbQ",
    :api_key => "WpK29FPquqFACvf1",
    :from => "we@wedxt.com",
    :fromname => "维斗喜帖网",
    :to => email,
    :subject => "维斗喜帖网-应用开通提醒！",
    :html => content
    
    puts response.code
  end

end
