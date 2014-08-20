#encoding: utf-8
namespace :member_notify do
  desc "send notify when user not pay site one day long after created site."
  task payment_notify: :environment do
    while true do
      puts "\ndo while condition.........................."
      index = Member.maximum(:payment_notify_count)
      index += 1
      Member.order("id desc").find_each do |member|
        #debug
        break if member.id < 368
        #the first time 
        if member.payment_notify_count == 0
          if member.sites.find{|s| s.site_payment.state != 'completed'}
            if Rails.env == 'production'
              SmsSendWorker.perform_async(member.auth_id, "亲，你的请柬还差最后一步就可以开通了，请点击这里：http://t.cn/RPnVVlx【维斗喜帖】")
            end
            member.payment_notify_count = index
            member.payment_notify_send_at = Time.now
            member.save!
            print member.id
            print ' '
          end
          next
        end

        #notify only send one time a day
        next if member.payment_notify_send_at < 1.day.ago
        next if member.sites.find{|s| s.site_payment.state != 'completed'}.nil?
        if Rails.env == 'production'
          SmsSendWorker.perform_async(member.auth_id, "亲，你的请柬还差最后一步就可以开通了，请点击这里：http://t.cn/RPnVVlx【维斗喜帖】")
        end
        member.payment_notify_count = index
        member.payment_notify_send_at = Time.now
        member.save!
        print member.id
        print ' '
      end
      puts "sleeping..."
      sleep(2.minutes)
    end
  end

  desc "send notify when festival(节日)"
  task festival_notify: :environment do
  end

  desc "send notify when have sale promote(活动促销)"
  task promote_notify: :environment do
  end

end
