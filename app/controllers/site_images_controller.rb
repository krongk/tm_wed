#encoding: utf-8

class SiteImagesController < ApplicationController
  #skip CSRF on create for Meitu show show
  skip_before_filter :verify_authenticity_token, only: [:create, :meitu_upload]

  before_filter :authenticate_auth
  before_action :set_site_image, only: [:show, :edit, :update, :destroy]
  layout 'simple', except: [:app]

  # 图片上传页面
  # 1. 显示已上传图片
  # 2. 上传表单
  def index
    @site_page = SitePage.find_by(id: params[:site_page_id])
    not_found if @site_page.nil?
    authorize!(@site_page.site)
    @site_images = SiteImage.where(site_page_id: @site_page.id).order("position ASC").page(params[:page] || 1)
  end

  #all copy from action :index
  #use for app upload
  def app
    @site_page = SitePage.find_by(id: params[:site_page_id])
    not_found if @site_page.nil?
    @site_images = SiteImage.where(site_page_id: @site_page.id).order("position ASC").page(params[:page] || 1)
  end

  #get 用于展示模态框
  def meitu_load
    @site_page = SitePage.find_by(id: params[:site_page_id])
    @site_image = SiteImage.find_by(id: params[:id])
    @site_page ||=  @site_image.try(:site_page)
    #editorType int， 为要嵌入的编辑器类型（1为轻量编辑，2为轻量拼图，3为完整版，5为头像编辑器，默认值1）
    @editor_type = params[:editor_type]
    @editor_type ||= 1
  end

  #post 用于保存修改
  def meitu_upload
    @site_image = SiteImage.find_by(id: params[:id])
    not_found if @site_image.nil?
    #替换图片
    @site_image.image = params[:site_image][:image]
    @site_image.save!
    @site_image.reload

    respond_to do |format|
      format.js
      format.html
    end
  end

  # GET /site_images/1
  # GET /site_images/1.json
  def show
  end

  # GET /site_images/new
  def new
    @site_image = SiteImage.new
  end

  # GET /site_images/1/edit
  def edit
  end

  # jQuery ajax提交
  # 见：app/assets/javascripts/site_images.js.coffee
  def create
    @site_image = SiteImage.create(site_image_params)
    respond_to do |format|
      format.js
      format.html 
    end
  end

  # PATCH/PUT /site_images/1
  # PATCH/PUT /site_images/1.json
  def update
    respond_to do |format|
      if @site_image.update(site_image_params)
        format.html { redirect_to @site_image, notice: 'Site image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @site_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site_images/1
  # DELETE /site_images/1.json
  def destroy
    url = params[:url]
    authorize!(@site_image.site_page.site)
    @site_image.destroy
    respond_to do |format|
      format.js { render 'destroy'}
      format.html { redirect_to url, notice: '删除成功！'}
    end
  end

  def sort
    params[:site_image].each_with_index do |id, index|
      SiteImage.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_image
      @site_image = SiteImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_image_params
      params.require(:site_image).permit(:site_page_id, :image, :image_file_name, :image_file_size,
      :image_content_type, :name, :description)
    end
end
