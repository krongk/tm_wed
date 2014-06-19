module SitesHelper
  #STATE = %w(opening pending paid completed canceled)
  def payment_state(site)
    site_payment = site.site_payment
    case site_payment.state
    when 'opening'; '等待付款'
    when 'pending'; '等待发货'
    when 'paid'; '等待收货'
    when 'completed'; '付款成功'
    when 'canceled'; '已经取消'
    when 'expired'; '已经过期'
    else '未知'
    end
  end
end
