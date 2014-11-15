class ResourceMusicsController < ApplicationController
  before_action :set_resource_music, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_auth

  # GET /resource_musics
  # GET /resource_musics.json
  def index
    @resource_musics = ResourceMusic.all
  end

  # GET /resource_musics/1
  # GET /resource_musics/1.json
  def show
  end

  # GET /resource_musics/new
  def new
    @resource_music = ResourceMusic.new
  end

  # GET /resource_musics/1/edit
  def edit
  end

  # POST /resource_musics
  # POST /resource_musics.json
  def create
    @resource_music = ResourceMusic.new(resource_music_params)
    @resource_music.user_id = current_user.id if current_user
    @resource_music.member_id = current_member.id if current_member

    respond_to do |format|
      if @resource_music.save
        @resource_music.url = @resource_music.asset.url
        if @resource_music.name.blank?
          begin
            @resource_music.name = @resource_music.asset.url.sub(/.*\/(.*)\.\w+$/, '\1')
          rescue
            @resource_music.name = @resource_music.id
          end
        end
        @resource_music.save

        format.html { redirect_to @resource_music, notice: '音乐上传成功.' }
        format.json { render action: 'show', status: :created, location: @resource_music }
      else
        format.html { render action: 'new' }
        format.json { render json: @resource_music.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resource_musics/1
  # PATCH/PUT /resource_musics/1.json
  def update
    authorize!(@resource_music)

    respond_to do |format|
      if @resource_music.update(resource_music_params)
        format.html { redirect_to @resource_music, notice: 'Resource music was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @resource_music.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_musics/1
  # DELETE /resource_musics/1.json
  def destroy
    authorize!(@resource_music)
    @resource_music.destroy
    respond_to do |format|
      format.html { redirect_to resource_musics_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource_music
      @resource_music = ResourceMusic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_music_params
      params.require(:resource_music).permit(:name, :url, :asset, :site_id)
    end
end
