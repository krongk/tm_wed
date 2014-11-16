#encoding: utf-8
class App::SiteController < ApplicationController
  include SHelper

  def new
    if params[:template_id].nil? || (@template = Templates::Template.find_by(id: params[:template_id])).nil?
      redirect_to portfolio_path, notice: t('notice.site.choose_template')
      return
    end
    if current_session
      redirect_to new_site_path(template_id: params[:template_id])
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
                val = params[:site].delete(key)
                SitePageKeystore.put(site_page.id, key, val) unless val.blank?
              end
            end
          end
          #3. get the first site page
          first_site_page ||= site_page
        end
        #add a comment
        SiteComment.create(site_id: @site.id, name: '维斗喜帖', content: '小维斗来过，提前送上一声祝福~')
        
        #send notice to admin
        # if Rails.env == 'production'
        #   SmsSendWorker.perform_async(ENV['ADMIN_PHONE'].split('|').join(','), "#{@site.user.try(:email) || @site.member.try(:auth_id)}创建了应用：#{get_site_url(@site)}")
        # end

        if mobile_device?
          format.html { redirect_to app_site_images_path(site_page_id: first_site_page.id), notice: t('notice.site.created') }
        else
          format.html { redirect_to site_site_steps_path(@site), notice: t('notice.site.created') }
        end
        format.json { render action: 'show', status: :created, location: @site }
      else
        format.html { render action: 'new', alert: '应用创建失败，请检查输入是否正确' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def ajax_get_member
    auth_id = params[:auth_id].to_s.strip
    if auth_id.match(/^1[3456789]\d{9}$/)
      member = Member.find_by(auth_id: auth_id)
      if member.present? && member.sites.any?
        txt = %{
          <script>$('#memberModal').modal('toggle');</script>
          <div class="alert alert-info alert-dismissible fade in" role="alert">
            <button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">×</span><span class="sr-only">关闭</span></button>
            <p>亲，小维斗检测到您已经在该网站创建了 <strong>#{member.sites.size.to_s}</strong> 个应用，为避免重复创建，请首先登录网站后台，然后再添加新应用.</p>
          </div
        }
        render text: txt and return
      end
    end
    render text: ''
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

    def member_params
      params.require(:member).permit(:auth_type, :auth_id)
    end

    def site_params
      params.require(:site).permit(:template_id, :title, :boy, :girl, :date, :address)
    end

end
