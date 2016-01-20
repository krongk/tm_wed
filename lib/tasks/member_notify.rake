#encoding: utf-8
#usage:
# => RAILS_ENV=production rake member_notify:payment_notify

namespace :member_notify do
  desc "send recent 20 notify when user not pay site one day long after created site."
  task recent_payment_notify: :environment do
    MAX_SEND_AMOUNT = 2
    #debug
    count = 0
    while true do
      puts "\ndo while condition..........................#{Time.now.to_s}"
      
      #do not send at night.
      if ("08:00"..."23:00").include?(Time.now.strftime("%H:%M"))
        Member.where("payment_notify_count < #{MAX_SEND_AMOUNT}").order("id desc").each do |member|
          #sleep(1.minutes)         
          #the first time 
          if member.payment_notify_count == 0
            if member.sites.find{|s| s.template.property != 'free' && s.site_payment.state != 'completed'}
              SmsSendWorker.perform_async(member.auth_id, "【维斗喜帖】亲，你的请柬还差最后一步就开通了，请通过本手机号登录后台完成支付：http://t.cn/RPnVVlx")
              member.payment_notify_count += 1
              member.payment_notify_send_at = Time.now
              member.save!
              print member.id
              print ' '
              count += 1
              sleep(1.minutes) if count%2 == 0
            end
            next
          end
        end
      end
      puts "sleeping..."
      sleep(3.hours)
    end
  end

  desc "send notify when user not pay site one day long after created site."
  task payment_notify: :environment do
    MAX_SEND_AMOUNT = 2
    #debug
    count = 0
    while true do
      puts "\ndo while condition..........................#{Time.now.to_s}"
      
      #do not send at night.
      if ("08:00"..."23:00").include?(Time.now.strftime("%H:%M"))
        Member.where("payment_notify_count < #{MAX_SEND_AMOUNT}").find_each do |member|
 	        #sleep(1.minutes)         
          #the first time 
          if member.payment_notify_count == 0
            if member.sites.find{|s| s.template.property != 'free' &&  s.site_payment.state != 'completed'}
              SmsSendWorker.perform_async(member.auth_id, "【维斗喜帖】亲，你的请柬还差最后一步就开通了，请通过本手机号登录后台完成支付：http://t.cn/RPnVVlx")
              member.payment_notify_count += 1
              member.payment_notify_send_at = Time.now
              member.save!
              print member.id
              print ' '
              count += 1
              break if count > 2
            end
            next
          end

          #notify only send one time a day
          next if member.payment_notify_send_at > 1.day.ago
          next if member.sites.find{|s| s.site_payment.state != 'completed'}.nil?
          
          SmsSendWorker.perform_async(member.auth_id, "【维斗喜帖】亲，你的请柬还差最后一步就可以开通了，请点击这里：http://t.cn/RPnVVlx")
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
    version_count = Member.first.festival_notify_count
    version_count ||= 1
    puts "startg...."
    Member.find_each do |member|
      #exit if member.id > 6
      SmsSendWorker.perform_async(member.auth_id, "月圆家圆人圆事圆团团圆圆，小维斗送给您的中秋祝福来啦：http://www.wedxt.com/s-ce6c【维斗喜帖】")
      Member.update(member.id, festival_notify_count: version_count + 1)
      print member.id
      print ' '
    end
  end

  desc "send notify when have sale promote(活动促销)"
  task promote_notify: :environment do
    version_count = 1
    Member.order("updated_at DESC").limit(100) do |member|
      SmsSendWorker.perform_async(member.auth_id, "这周因为服务器问题，维斗喜帖已更换致华中双线机房，请放心使用，为您带来的不便深表歉意")
      member.promote_notify_count = version_count
      member.save!
      print member.id
      print ' '
    end
  end

end
