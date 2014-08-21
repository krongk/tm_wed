class MembersController < ApplicationController
  before_action :set_member, only: [:new_token, :edit, :update, :destroy]

  def new
    @member = Member.new
  end

  #login
  #{"auth_type"=>"phone", "auth_id"=>"12588885556"}
  def create
    member = Member.find_by(auth_type: member_params[:auth_type], auth_id: member_params[:auth_id])
    if member
      #old user, judge if he has any sites, redirect to send_token
      #else like a new user
      if member.try(:sites)
        session[:token] = nil
        session[:token] = member.id
        #send token
        if Rails.env == 'production'
          TokenSendWorker.perform_async(member.auth_id, generate_token(member))
        end
        return redirect_to new_token_members_path(id: member.id), notice: '验证码已发送到你手机，请注意查收！'
      else
        get_session(member)
      end
      redirect_to portfolio_path, notice: '登录成功！请选择一个喜欢的模板' and return
    else #new user
      member = Member.new(member_params)
      if member.save
        get_session(member)
        redirect_to portfolio_path, notice: '注册成功！请选择一个喜欢的模板'
      else
        redirect_to new_user_session_path, alert: '注册或登录失败，请检查你的输入是否正确。'
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    session[:member] = nil
    redirect_to root_path, notice: '退出成功！'
  end

  def new_token
  end

  #"id"=>"3", "auth_token"=>"ewf",
  def verify_token
    member = Member.find(params[:id])
    if member.auth_token.to_s.downcase == params[:auth_token].to_s.strip.downcase
      get_session(member)
      if member.sites.any?
        redirect_to sites_path, notice: '登录成功！'
      else
        redirect_to portfolio_path, notice: '登录成！请选择一个喜欢的模板'
      end
    else
      render new_token_members_path, id: member.id, notice: '短信验证失败，请重新登录！'
    end
  end

  def qc_callback
    puts request
    # app_id = '101148468'
    # app_key = '861e30f9adefb07ea5485ecd0f3308a9'
    # redirect_uri = 'http://www.wedxt.com/members/qc_callback'

    # #Step1：获取Authorization Code
    # # param = {'response_type' => 'code', 
    # #   'client_id' => app_id,
    # #   'redirect_uri' => URI.encode(redirect_uri),
    # #   'state' => 'test'
    # # }.map{|k,v| "#{k}=#{v}"}.join('&')
    # # if open('https://graph.qq.com/oauth2.0/authorize?' + param).read =~ /\?code=(.*)&state=/i
    # #   code = $1
    # # end
   
    # #Step2：通过Authorization Code获取Access Token
    # @token ||= open('https://graph.qq.com/oauth2.0/token?grant_type=authorization_code&client_id=' + app_id + 
    #   '&client_secret=' + app_key + 
    #   '&code=' + params[:code].to_s + '&redirect_uri='+ redirect_uri).read[/(?<=access_token=)\w{32}/]
    # #获取Openid
    # @openid ||= open('https://graph.qq.com/oauth2.0/me?access_token=' + @token).read[/\w{32}/]    
    # #获取通用验证参数
    # @auth ||= '?access_token=' + @token + '&oauth_consumer_key=' + app_id + '&openid=' + @openid

    # back=open("https://graph.qq.com/user/get_user_info" + @auth ).read.force_encoding('utf-8')

    # puts back 
  end

  private
    def generate_token(member)
      #token = SecureRandom.hex(2) => 4 chars lime '43a5'
      token = SecureRandom.random_number.to_s[2..7]
      member.auth_token = token
      member.save
      return token
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:auth_type, :auth_id)
    end
end
