#encoding: utf-8
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
    #1. find or create member
    @member = get_member(member_params)
    if @member.nil?
      redirect_to app_site_new_path(params.merge!(template_id: site_params[:template_id])), alert: '你提供的手机号不正确，请重试' and return
    end
    get_session(@member)

    #2. create site
    @site = Site.new(title: site_params.delete(:title))
    @site.member_id = current_member.id if current_member
    @site.template_id = site_params[:template_id]
    @site.description = "我们定于#{params[:site][:date]}举行宴请典礼，敬请光临！"

    respond_to do |format|
      if @site.save
        #initialize default key-value
        params[:site].merge!(boy_phone: member_params[:auth_id])
        params[:site].merge!(girl_phone: member_params[:auth_id])
        params[:site].merge!(mobile_phone: member_params[:auth_id])
        params[:site].merge!(banner: '/banners/1.jpg')
        params[:site].merge!(music: '/musics/mp3/fanweiqi_zui-zhong-yao-de-jue-ding.mp3')
        params[:site].merge!(welcome: "各位亲朋好友：在这温馨浪漫，喜悦甜蜜的日子里我俩决定于#{params[:site][:date]}举行宴请典礼，届时敬备酒宴，欢迎您到来分享这份喜悦，您的光临将使我们的婚宴增添万分光彩!")
        params[:site].merge!(story: '1998年的夏天，两个年轻的学生背着一大堆的理想步入高一的学堂，在中学那座老旧的红墙教室里，他们第一次相遇；之后他俩成了相交甚好的同学，开启了一段冲往象牙塔的梦想之旅。')
        params[:site].merge!(wed_description: %{
<h5>07:00  新郎的接亲队伍准时出发到新娘家</h5>
  08:30  排好车队新人出发返回新房<br/>
<h5>17:00  宾客签到</h5>
<h5>18:00  婚礼仪式正式开始</h5>
  18:30  新人敬酒<br/>
  19:40  婚礼仪式结束，客人茶歇时间<br/>
          })
        params[:site].merge!(content:  %{
这是一个微相册示例，你可以通过手机简单创建，适用于照片分享，电子请帖，活动邀请，报名等各种应用场景。
制作喜帖+QQ：77632132
+微信：xuejiang_song    
官网访问地址: www.WedXT.com

高大上的结婚喜帖
私人定制，打造属于你的真挚邀请
一生一次，再一次引爆你的朋友圈
          })

        #build site_page via template_page
        first_site_page = nil
        Templates::Page.where(template_id: @site.template_id).order("position ASC").each do |temp_page|

          #1. create site page
          site_page = @site.site_pages.create(
            site_id: @site.id, 
            template_page_id: temp_page.id,
            title: temp_page.title
          )
          #2. assign key value
          if params[:site].any? && temp_form = Templates::Keystore.get(temp_page, 'form')
            form_html = temp_form.value
            params[:site].each_pair do |key, value|
              if form_html =~ / name="site_page\[#{key}\]"/i
                SitePageKeystore.put(site_page.id, key, params[:site].delete(key))
              end
            end
          end
          #3. get the first site page
          first_site_page ||= site_page
        end
        #send notice to admin
        if Rails.env == 'production'
          SmsSendWorker.perform_async(ENV['ADMIN_PHONE'].split('|').join(','), "#{@site.user.try(:email) || @site.member.try(:auth_id)}创建了应用：#{get_site_url(@site)}")
        end
        #redirect
        format.html { redirect_to app_site_images_path(site_page_id: first_site_page.id), notice: t('notice.site.created') }
        format.json { render action: 'show', status: :created, location: @site }
      else
        format.html { render action: 'new', alert: '应用创建失败，请检查输入是否正确' }
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
