class HomeController < ApplicationController
  layout :resolve_layout

  def index
    #render text: params and return
  end

  def templates
    @cates = Templates::Cate.all
    @templates = Templates::Template.where("cate_id in (1,2)").order("updated_at DESC").paginate(page: params[:page] || 1, per_page: 6)
  end
  def template
    @template = Templates::Template.find(params[:id])
  end

  def case
    @templates = Templates::Template.where("cate_id in (1,2)").order("updated_at DESC")
    @last_template = @templates.pop #use for filter style
    @sites = Site.sites_has_images.where("sites.status IS NULL OR sites.status not in('vip', 'thief')").paginate(page: params[:page] || 1, per_page: 9)
  end

  def vip
    @show_contact = false #this var is for turn off footer contact form, used in layouts/_contact.html.erb
    @template = Templates::Template.find_by(id: params[:template_id])
    #render text: params and return
  end

  def pricing

  end

  def search

  end

  #post list
  def blog
    @posts = Admin::Page.joins(:channel).where("admin_channels.short_title = ?", 'wedxt').order("updated_at DESC").paginate(page: params[:page], per_page: 9)
  end

  def post
    @post = Admin::Page.find_by(short_title: params[:id])
  end
  
  #用于page_steps中对话框扩展： 选择封面、选择音乐。
  #这些特殊的内容，不放在tm_admin中。

  #在弹出窗口的链接中如果想要显示该页面上传的图片，在需要传递site_page参数，用于获取site_page下面的图片列表：
  #<a data-target="#bannerModal" data-toggle="modal" href="/home/dialog_banner?site_page_id=<%=@site_page.id%>">
  # url: '/home/dialog_banner?site_page_id=' + @site_page.id.to_s
  def dialog_banner
   site_page = SitePage.find_by(id: params[:site_page_id])
   @site_images = site_page.site_images if site_page
   @site_images ||= []
  end

  def dialog_music
    @musics = ResourceMusic.order("updated_at DESC").page(params[:page])
    @my_musics = ResourceMusic.get_my_musics(current_session)
  end

  private
    def resolve_layout
      case action_name
      when /dialog_.*/ 
        false
      else
        "application"
      end
    end

end
