class MembersController < ApplicationController
  before_action :set_member, only: [:edit, :update, :destroy]

  def new
    @member = Member.new
  end

  #login
  #{"auth_type"=>"phone", "auth_id"=>"12588885556"}
  def create
    member = Member.find_by(auth_type: member_params[:auth_type], auth_id: member_params[:auth_id])
    if member #old user
      #judge if he has any sites, redirect to send_token
      #else like a new user
      if member.try(:sites)
        session[:token] = nil
        session[:token] = member.id
        #send token &&  limit to send sms frequently
        if Time.now - member.token_created_at < 120
          return redirect_to new_token_members_path, notice: '您在2分钟内已经提交过一次了，请检查手机是否已收到验证码！'
        else
          SmsSendWorker.perform_async(member.auth_id, "【维斗喜帖】登录验证码#{generate_token(member)}，请在10分钟内登录网站验证")
        end
        return redirect_to new_token_members_path, notice: '验证码已发送到你手机，请注意查收！'
      else
        get_session(member)
      end
      redirect_to portfolio_path, notice: '登录成功！请选择一个喜欢的模板' and return
    else #new user
      member = Member.new(member_params)
      if member.save
        get_session(member)
        redirect_to templates_path, notice: '注册成功！请选择一个喜欢的模板'
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
    if session[:token].nil?
      redirect_to new_user_session_path, notice: '登录会话已过期，请重新登录！' and return
    end
    #
    member = Member.find(params[:id])
    if member.present? && member.auth_token.to_s.downcase == params[:auth_token].to_s.strip.downcase
      get_session(member)
      Member.increase_login_count(member.id)
      if member.sites.any?
        redirect_to sites_path, notice: '登录成功！'
      else
        redirect_to portfolio_path, notice: '登录成功！请选择一个喜欢的模板创建应用。'
      end
      session[:token] = nil
    else
      session[:token] = nil
      redirect_to new_user_session_path, notice: '短信验证失败，请重新登录！'
    end
  end

  private
    def generate_token(member)
      #token = SecureRandom.hex(2) => 4 chars lime '43a5'
      token = SecureRandom.random_number.to_s[2..5]
      member.auth_token = token
      member.token_created_at = Time.now
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
