class App::SiteController < ApplicationController
  def new
    if params[:template_id].nil? || (@template = Templates::Template.find_by(id: params[:template_id])).nil?
      redirect_to portfolio_path, notice: t('notice.site.choose_template')
      return
    end
    
  end
  #"member"=>{"phone"=>"18080801080"}, 
  #"site"=>{"boy"=>"梁山伯", "girl"=>"祝英台", "date"=>"2014-07-18", "address"=>"成都锦江区滨江东路9号"}}
  def create
    #find or create member
    @member = get_member(member_params)
    if @member.nil?
      redirect_to app_site_new_path(params.merge!(template_id: params[:site][:template_id])), alert: '你提供的手机号不正确，请重试' and return
    end
    get_session(@member)
    #create site
    @site = Site.new(title: site_params.delete(:title))
    @site.member_id = current_member.id if current_member

    respond_to do |format|
      if @site.save
        #build site_page via template_page
        Templates::Page.where(template_id: @site.template_id).order("position ASC").each do |temp_page|
          @site.site_pages.create(
            site_id: @site.id, 
            template_page_id: temp_page.id,
            title: temp_page.title
          )
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

  def upload
  end

  def preview
  end

  private
    #login
    #{"auth_type"=>"phone", "auth_id"=>"12588885556"}
    def get_member(member_params)
      member = Member.find_by(auth_type: member_params[:auth_type], auth_id: member_params[:auth_id])
      return member if member.present?
      member = Member.new(member_params)
      unless member.save
        return nil
      end
      member
    end
    def create_member(member_params)
      member = Member.find_by(auth_type: member_params[:auth_type], auth_id: member_params[:auth_id])
      if member
        #old user, judge if he has any sites, redirect to send_token
        #else like a new user
        if member.try(:sites)
          session[:token] = nil
          session[:token] = member.id
          #send token
          TokenSendWorker.perform_async(member.auth_id, generate_token(member))
          return render new_token_members_path, id: member.id, notice: '验证码已发送！'
        else
          get_session(member)
        end
      else #new user
        member = Member.new(member_params)
        if member.save
          get_session(member)
        else
          redirect_to new_user_session_path, alert: '注册或登录失败，请检查你的输入是否正确。' and return
        end
      end
    end

    def member_params
      params.require(:member).permit(:auth_type, :auth_id)
    end
    def site_params
      params.require(:site).permit(:template_id, :title, :boy, :girl, :date, :address)
    end

end
