require 'digest/md5'
require 'open-uri'

module SmsBao
  # SMS_STATUS = {0 => 'success', 
  #   30 => 'password error',
  #   40 => 'bad account',
  #   41 => 'no money',
  #   42 => 'account expired',
  #   43 => 'IP denied',
  #   50 => 'content sensitive',
  #   51 => 'bad phone number',
  # }
  def self.send(user_name, password, phones, content)
    result = nil
    password = Digest::MD5.hexdigest password
    begin
      #surl = "http://www.smsbao.com/sms?u=#{user_name}&p=#{password}&m=#{phones}&c=#{URI.escape(content)}"
      surl = "http://api.smsbao.com/sms?u=inruby&p=#{password}&m=#{phones}&c=#{URI.escape(content)}"
      open(surl) {|f|
        f.each_line {|line| result = line}
      }
    rescue => ex
      return ex.message
    end
    result
  end
  
  def self.query(user_name, password)
    result = nil
    password = Digest::MD5.hexdigest password
    begin
      open("http://www.smsbao.com/query?u=inruby&p=#{password}") {|f|
        f.each_line {|line| result = line}
      }
    rescue => ex
      return ex.message
    end
    result
  end
end