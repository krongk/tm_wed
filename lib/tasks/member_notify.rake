#encoding: utf-8
#usage:
# => RAILS_ENV=production rake member_notify:payment_notify

namespace :member_notify do
  desc "send notify when user not pay site one day long after created site."
  task payment_notify: :environment do
    MAX_SEND_AMOUNT = 2
    #debug
    #count = 0
    while true do
      puts "\ndo while condition..........................#{Time.now.to_s}"
      
      #do not send at night.
      if ("08:00"..."23:00").include?(Time.now.strftime("%H:%M"))
        Member.where("payment_notify_count < #{MAX_SEND_AMOUNT}").find_each do |member|
          
          #the first time 
          if member.payment_notify_count == 0
            if member.sites.find{|s| s.site_payment.state != 'completed'}
              SmsSendWorker.perform_async(member.auth_id, "亲，你的请柬还差最后一步就开通了，请通过本手机号登录后台完成支付：http://t.cn/RPnVVlx【维斗喜帖】")
              member.payment_notify_count += 1
              member.payment_notify_send_at = Time.now
              member.save!
              print member.id
              print ' '
              # count += 1
              # break if count > 1
            end
            next
          end

          #notify only send one time a day
          next if member.payment_notify_send_at > 1.day.ago
          next if member.sites.find{|s| s.site_payment.state != 'completed'}.nil?
          
          SmsSendWorker.perform_async(member.auth_id, "亲，你的请柬还差最后一步就可以开通了，请点击这里：http://t.cn/RPnVVlx【维斗喜帖】")
          member.payment_notify_count += 1
          member.payment_notify_send_at = Time.now
          member.save!
          print member.id
          print ' '
        end
      end
      puts "sleeping..."
      sleep(3.hours)
    end
  end

  desc "send notify when festival(节日)"
  task festival_notify: :environment do
    version_count = 1
    Member.find_each do |member|
      SmsSendWorker.perform_async(member.auth_id, "月圆家圆人圆事圆团团圆圆，小维斗送给您的中秋祝福：http://t.cn/RPnVVlx【维斗喜帖】")
      member.festival_notify_count = version_count
      member.save!
      print member.id
      print ' '
    end
  end

  desc "send notify when have sale promote(活动促销)"
  task promote_notify: :environment do
    version_count = 1
    Member.find_each do |member|
      SmsSendWorker.perform_async(member.auth_id, "微相册免费啦，点击这里查看：http://t.cn/RPnVVlx【维斗喜帖】")
      member.promote_notify_count = version_count
      member.save!
      print member.id
      print ' '
    end
  end

end
