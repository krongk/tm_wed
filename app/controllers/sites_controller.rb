class SitesController < ApplicationController
  include SHelper
  before_filter :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy]

  #skip CSRF on update from tempp form.
  # skip_before_filter :verify_authenticity_token, :only => [:temp_form_update]

  # GET /sites
  # GET /sites.json
  def index
    @sites = current_user.sites.page(params[:page] || 1)
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    @site_images = SiteImage.joins(:site_page).where("site_pages.site_id = ?", @site.id)
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
    @site.user_id = current_user.id

    respond_to do |format|
      if @site.save
        #build site_page via template_page
        Templates::Page.where(template_id: @site.template_id).order("position ASC").each do |temp_page|
          @site.site_pages.create(
            site_id: @site.id, 
            template_page_id: temp_page.id,
            title: temp_page.title)
        end
        #create qrcode
        generate_qrcode(@site)
        generate_qrcode(@site) unless File.exist?(File.join(Rails.root, 'public', @site.qrcode))
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
        generate_qrcode(@site) unless File.exist?(File.join(Rails.root, 'public', @site.qrcode))
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
    #render text: params and return

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
      @site = Site.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_params
      params.require(:site).permit(:user_id, :template_id, :short_title, :title, :description, :domain, :status, :is_publiched, :is_comment_show, :updated_by, :note)
    end

    def generate_qrcode(page)
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
