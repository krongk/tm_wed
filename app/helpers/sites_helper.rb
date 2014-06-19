module SitesHelper
  #STATE = %w(opening pending paid completed canceled)
  def payment_state(site)
    site_payment = site.site_payment
    case site_payment.state
    when 'opening'; '等待付款'
    else '未知'
    end
  end
end
