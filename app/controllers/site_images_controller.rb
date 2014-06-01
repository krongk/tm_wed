class SiteImagesController < ApplicationController
  before_action :set_site_image, only: [:show, :edit, :update, :destroy]
  layout 'simple'

  # 图片上传页面
  # 1. 显示已上传图片
  # 2. 上传表单
  def index
    @site_page = SitePage.find_by(id: params[:site_page_id])
    not_found if @site_page.nil?
    @site_images = SiteImage.where(site_page_id: @site_page.id).order("position ASC").page(params[:page] || 1)
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
    @site_image.destroy
    respond_to do |format|
      format.html { redirect_to site_images_url }
      format.json { head :no_content }
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
