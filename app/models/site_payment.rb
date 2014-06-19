class SitePayment < ActiveRecord::Base
  belongs_to :site
  validates  :site_id, :uniqueness => {:scope => [:site_id], :message => "已经存在"}

  STATE = %w(opening pending paid completed canceled)
 
  scope :showable, where(:state => 'opening')

  validates_presence_of :price
  validates_inclusion_of :state, :in => STATE

  STATE.each do |state|
    define_method "#{state}?" do
      self.state == state
    end
  end

  def pend
    if opening?
      update_attributes(
        :pending_at => Time.now.utc,
        :state       => 'pending'
      )
    end
  end

  def complete
    if pending? or paid?
      add_plan if pending?

      update_attributes(
        :completed_at => Time.now.utc,
        :state       => 'completed'
      )
    end
  end

  def cancel
    if pending? or paid?
      remove_plan if paid?
      update_attributes(
        :state       => 'canceled',
        :canceled_at => Time.now.utc
      )
    end
  end

  def pay
    if pending?
      update_attributes(
        :state   => 'paid',
        :paid_at => Time.now.utc
      )
      add_plan
    end
  end

  def add_plan
    puts "add plan .........................."
    # start_at = (space.plan_expired_at && space.plan_expired_at > Time.now.utc) ? space.plan_expired_at : Time.now.utc

    # update_attributes(
    #   :start_at    => start_at
    # )

    # space.update_attributes(
    #   :plan => plan,
    #   :plan_expired_at => start_at + quantity.months
    # )
  end

  def remove_plan
    # space.update_attributes(
    #   :plan_expired_at => space.plan_expired_at - quantity.months
    # )
    # space.orders.where(:start_at.gt => start_at).each do |order|
    #   order.update_attribute :start_at, order.start_at - quantity.months
    # end
  end

  def pay_url(site)
    # options = {
    #   :out_trade_no      => id.to_s,         # 20130801000001
    #   :subject           => "账户充值：#{price}",
    #   :logistics_type    => 'DIRECT',
    #   :logistics_fee     => '0',
    #   :logistics_payment => 'SELLER_PAY',
    #   :price             => price,
    #   :quantity          => 1,
    #   #:discount          => '20.00',
    #   :return_url        => user_payment_path(current_user, @payment), # https://writings.io/orders/20130801000001
    #   :notify_url        => user_payment_notify_path(current_user, @payment_notify)  # https://writings.io/orders/20130801000001/alipay_notify
    # }

    # Alipay::Service#create_partner_trade_by_buyer_url # 担保交易
    # Alipay::Service#trade_create_by_buyer_url         # 标准双接口
    # Alipay::Service#create_direct_pay_by_user_url     # 即时到帐
    Alipay::Service.trade_create_by_buyer_url(
      :out_trade_no      => id.to_s,
      :price             => price,
      :quantity          => 1,
      # :discount          => discount,
      :subject           => "账户充值：#{price}",
      :logistics_type    => 'DIRECT',
      :logistics_fee     => '0',
      :logistics_payment => 'SELLER_PAY',
      :return_url        => Rails.application.routes.url_helpers.site_payment_url(site_id: site.id, id: id, protocol: (ENV["SSL"] ? 'https' : 'http'), :host => ENV["HOST_NAME"]),
      :notify_url        => Rails.application.routes.url_helpers.site_alipay_notify_url(site_id: site.id, protocol: (ENV["SSL"] ? 'https' : 'http'), :host => ENV["HOST_NAME"])
    )

    #Wap pay
    # options = {
    #   :req_data => {
    #     :out_trade_no  => id.to_s,         # 20130801000001
    #     :subject       => 'YOUR_ORDER_SUBJECCT',   # Writings.io Base Account x 12
    #     :total_fee     => price,
    #     :notify_url    => Rails.application.routes.url_helpers.site_alipay_notify_url(site_id: site.id, protocol: (ENV["SSL"] ? 'https' : 'http'), :host => ENV["HOST_NAME"]),
    #     :call_back_url => Rails.application.routes.url_helpers.site_payment_url(site_id: site.id, id: id, protocol: (ENV["SSL"] ? 'https' : 'http'), :host => ENV["HOST_NAME"])
    #   }
    # }
    # token = Alipay::Service::Wap.trade_create_direct_token(options)
    # Alipay::Service::Wap.auth_and_execute(request_token: token)
  end

  def send_good
    puts "send good..............."
    Alipay::Service.send_goods_confirm_by_platform(:trade_no => trade_no, :logistics_name => ENV["SITE_NAME"], :transport_type => 'DIRECT')
  end
end
