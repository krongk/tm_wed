#encoding: utf-8
#usage:
# => RAILS_ENV=production rake user_notify:payment_notify

namespace :user_notify do
  desc "send recent 20 notify when user not pay site one day long after created site."
  task recent_payment_notify: :environment do
   MAX_SEND_AMOUNT = 2
    #debug
    count = 0
    while true do
      puts "\ndo while condition..........................#{Time.now.to_s}"
      
      #do not send at night.
      if ("08:00"..."23:00").include?(Time.now.strftime("%H:%M"))
        User.where("payment_notify_count < #{MAX_SEND_AMOUNT}").order("id desc").find_each do |user|
          #sleep(1.minutes)         
          #the first time 
          if user.payment_notify_count == 0
            if user.sites.find{|s| !['vip', 'vip-recommend'].include?(s.status) && s.site_payment.state != 'completed'}
              MailSendWorker.perform_async(user.email, "【维斗喜帖】亲，你的请柬还差最后一步就开通了，请点击链接登录后台完成支付：<a href='http://t.cn/RPnVVlx'>http://www.wedxt.com</a>")
              user.payment_notify_count += 1
              user.payment_notify_send_at = Time.now
              user.save!
              print user.id
              print ' '
              count += 1
              sleep(1.minutes) if count%2 == 0
            end
            next
          end
        end
      end
      puts "sleeping..."
      sleep(2.hours)
    end
  end
end