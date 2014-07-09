class SiteCommentsController < ApplicationController
  before_filter :authenticate_auth, only: [:destroy]
  before_action :set_site_comment, only: [:show, :edit, :update, :destroy]
  #skip CSRF on create.
  skip_before_filter :verify_authenticity_token

  layout false, only: [:new, :create]

  # GET /site_comments
  # GET /site_comments.json
  def index
    @site = Site.find_by(id: params[:site_id])
    redirect_to sites_url and return if @site.nil?
    redirect_to sites_url and return unless can_access_site_comment?(@site)
    @site_comments = @site.site_comments.order("updated_at DESC").page(params[:page])
  end

  # GET /site_comments/1
  # GET /site_comments/1.json
  def show
  end

  # GET /site_comments/new
  def new
    @site_comment = SiteComment.new
  end

  # GET /site_comments/1/edit
  def edit
  end

  # POST /site_comments
  # POST /site_comments.json
  def create
    @site_comment = SiteComment.new(site_comment_params)

    respond_to do |format|
      if @site_comment.save
        #send notice to admin
        if Rails.env == 'production' && @site_comment.site_id == 1
          SmsSendWorker.perform_async(ENV['ADMIN_PHONE'].split('|').join(','), "#{@site_comment.mobile_phone}给你留言了：#{@site_comment.content}")
          SmsSendWorker.perform_async(@site_comment.mobile_phone, "感谢你的留言！试试手机上创建喜帖：http://www.wedxt.com【维斗喜帖】")
        end

        format.html { render text: 'success' }
        format.json { render action: 'show', status: :created, location: @site_comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @site_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site_comments/1
  # PATCH/PUT /site_comments/1.json
  def update
    respond_to do |format|
      if @site_comment.update(site_comment_params)
        format.html { redirect_to @site_comment, notice: 'Site comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @site_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site_comments/1
  # DELETE /site_comments/1.json
  def destroy
    @site_comment.destroy
    respond_to do |format|
      format.html { redirect_to site_comments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_comment
      @site_comment = SiteComment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_comment_params
      params.require(:site_comment).permit(:site_id, :template_page_id, :name, :mobile_phone, :tel_phone, :email, :qq, :weixin, :gender, :birth, :address, :hobby, :content, :content2, :content3, :status, :updated_by, :note)
    end

    def can_access_site_comment?(site)
      return true if site.user_id.present? && site.user_id == current_user.id
      return true if site.member_id.present? && site.member_id == current_member.id
      return false
    end
end
