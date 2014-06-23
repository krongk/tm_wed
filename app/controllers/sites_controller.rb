class SitesController < ApplicationController
  include SHelper
  #alipay notify 获得alipay返回过来的异步调用，添加下面一行，否则422错误
  skip_before_filter :verify_authenticity_token, :only => [:alipay_notify]
  #权限验证过滤掉alipay_notify
  before_filter :authenticate_auth, except: [:preview, :alipay_notify]
  before_action :set_site, only: [:show, :edit, :update, :destroy, :preview, :payment, :themes, :set_theme, :verify_payment_token]

  # GET /sites
  # GET /sites.json
  def index
    if current_user
      @sites = current_user.sites.page(params[:page] || 1)
    elsif current_member
      @sites = current_member.sites.page(params[:page] || 1)
    end
  end

  def preview
    
  end

  #用户付款页面
  #同时也用于支付宝回调，带参数。
  #  Parameters: {"id"=>"9", "buyer_email"=>"180xxxx0818", "buyer_id"=>"2081804692", "exterface"=>"trade_create_by_buyer", 
  # "is_success"=>"T", "logistics_fee"=>"0.00", "logistics_payment"=>"SELLER_PAY", "logistics_type"=>"DIRECT", 
  # "notify_id"=>"RqPnCoPT3K9%2FL4GdP4QUlJPCi0i", "notify_time"=>"2014-06-19 15:59:38", \
  # "notify_type"=>"trade_status_sync", "out_trade_no"=>"9", "payment_type"=>"1", "receive_address"=>"null", 
  # "seller_email"=>"kenrxxx@xx.com", "seller_id"=>"208566fwef3013", "subject"=>"账户充值：1.0", "total_fee"=>"1.00",
  #  "trade_no"=>"201407xx90469", "trade_status"=>"TRADE_FINISHED", "sign"=>"112e39xx9c059ea12210fe4b2", "sign_type"=>"MD5", "site_id"=>"8"}
  def payment
    @site_payment = @site.site_payment
    # callback_params = params.except(*request.path_parameters.keys)
    # if callback_params.any?
    #   render site_payment_path(@site), notice: "支付宝支付状态: #{callback_params[:trade_status]}" and return
    # end
  end
  
  # 支付宝异步消息接口
  # 注意：必须在服务器上正常运行才能测试，本地localhost阿里是不会自动post这个接口的
  def alipay_notify
    notify_params = params.except(*request.path_parameters.keys)
    # 先校验消息的真实性
    if Alipay::Notify.verify?(notify_params)
      # 获取交易关联的订单
      @payment = SitePayment.find params[:out_trade_no]

      case params[:trade_status]
      when 'WAIT_BUYER_PAY'
        # 交易开启
        @payment.update_attribute :trade_no, params[:trade_no]
        @payment.pend
      when 'TRADE_FINISHED'
        # 交易完成
        need_mail = @payment.pending?
        @payment.complete
        #SystemMailer.delay.payment_payment_success(@payment.id.to_s) if need_mail
      when 'TRADE_CLOSED'
        # 交易被关闭
        @payment.cancel
        #SystemMailer.delay.payment_cancel(@payment.id.to_s)
      when 'WAIT_SELLER_SEND_GOODS'
        # 买家完成支付
        @payment.pay
        # 虚拟物品无需发货，所以立即调用发货接口
        @payment.send_good
        #SystemMailer.delay.payment_payment_success(@payment.id.to_s)
      else
        # do nothing
      end

      #@payment.payment_notifies.create!(verify: true, payment_number: "p#{@payment.id}r#{rand(30034)}", payment_count: @payment.price, state: 'income', cate: '在线充值', status: params[:trade_status])
      # 成功接收消息后，需要返回纯文本的 ‘success’，否则支付宝会定时重发消息，最多重试7次。 
      render :text => 'success'
    else
      #@payment.payment_notifies.create!(verify: false, payment_number: "p#{@payment.id}r#{rand(30034)}", payment_count: @payment.price, state: 'income', cate: '在线充值', status: params[:trade_status])

      render :text => 'error'
    end
  end

  #验证激活码
  #1. 激活码是否有效
  #2. 
  def verify_payment_token
    #render text: params and return
    #{"code"=>"2faff2f", "commit"=>"验 证", "action"=>"verify_payment_token", "controller"=>"sites", "site_id"=>"21"}
    if payment_token = Payment::Token.active.where("code = ?", params[:code].strip).first
      #update payment_token
      payment_token.actived_by = current_session.id
      payment_token.actived_site_id = @site.id
      payment_token.status = 'inactive'
      payment_token.save
      #update site_payment
      site_payment = @site.site_payment
      site_payment.state = 'completed'
      site_payment.pay_type = 'token'
      site_payment.completed_at = Time.now
      site_payment.updated_by = current_session.id
      site_payment.note = "激活码验证"
      site_payment.save

      redirect_to site_path(@site), notice: t('notice.site.active_token')
    elsif Payment::Token.inactive.where("code = ?", params[:code].strip).first
      redirect_to site_payment_path(@site), alert: t('notice.site.inactive_token')
    else
      redirect_to site_payment_path(@site), alert: t('notice.site.invalid_token')
    end
  end

  #show themes list
  def themes
    #@site = Site.find(params[:site_id])
    @themes = Templates::Template.find_by(id: @site.template_id).try(:themes)
  end
  #set theme for this site
  #{"theme_id"=>"2", "action"=>"set_theme", "controller"=>"sites", "site_id"=>"8"}
  def set_theme
    @site.theme_id = params[:theme_id]
    @site.save
    redirect_to sites_path, notice: t('notice.site.set_theme')
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    
  end

  # GET /sites/new
  def new
    if params[:template_id].nil? || Templates::Template.find_by(id: params[:template_id]).nil?
      redirect_to portfolio_path, notice: t('notice.site.choose_template')
      return
    end
    @site = Site.new
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(site_params)
    @site.user_id = current_user.id if current_user
    @site.member_id = current_member.id if current_member

    respond_to do |format|
      if @site.save
        #build site_page via template_page
        Templates::Page.where(template_id: @site.template_id).order("position ASC").each do |temp_page|
          @site.site_pages.create(
            site_id: @site.id, 
            template_page_id: temp_page.id,
            title: temp_page.title)
        end
        #send notice to admin
        if Rails.env == 'production'
          SmsSendWorker.perform_async(ENV['ADMIN_PHONE'].split('|').join(','), "#{@site.user.try(:email) || @site.member.try(:auth_id)}创建了应用：#{get_site_url(@site)}")
        end
        #redirect
        format.html { redirect_to site_site_steps_path(@site), notice: t('notice.site.created') }
        format.json { render action: 'show', status: :created, location: @site }
      else
        format.html { render action: 'new' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to site_site_steps_path(@site), notice: t('notice.site.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end

  def send_sms   
    if ENV['SMS_BAO_USER'].nil? || ENV['SMS_BAO_PASSWORD'].nil? || ENV['SMS_MAX_CHARACTER_COUNT'].nil?
      raise "请配置短信发送接口的环境变量"
    end
    SmsSendWorker.perform_async(params[:mobile_phone], params[:content])
    respond_to do |format|
      format.js {}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find_by(id: params[:id])
      #for preview/themes/set_theme
      @site ||= Site.find_by(id: params[:site_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_params
      params.require(:site).permit(:user_id, :member_id, :template_id, :short_title, :title, :description, :domain, :is_publiched, :is_comment_show, :updated_by, :note)
    end

    #expired, we used QRcode API to generate qrcode
    def generate_qrcode_bak(page)
      url = get_site_url(page)
      return if url.blank?
      qr = RQRCode::QRCode.new( url, :size => 6, :level => :h )
      png = qr.to_img # returns an instance of ChunkyPNG

      qr_dir = File.join(Rails.root, 'public', 'qrcode')
      FileUtils.mkdir_p qr_dir
      png_path = File.join(qr_dir, "#{page.id}.png")
      if File.exist? png_path
        #FileUtils.rm png_path
      else
        png.resize(120, 120).save(png_path)
      end     
    end

end
