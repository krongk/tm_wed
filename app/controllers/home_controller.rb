class HomeController < ApplicationController
  layout :resolve_layout

  def index
    #render text: params and return
  end

  def templates
    @templates = Templates::Template.where("cate_id in (1,2)").order("updated_at DESC").paginate(page: params[:page] || 1, per_page: 6)
  end
  def template
    @template = Templates::Template.find(params[:id])
  end

  def case
    @templates = Templates::Template.where("cate_id in (1,2)").order("updated_at DESC")
    @last_template = @templates.pop #use for filter style
    @sites = Site.order("updated_at DESC").paginate(page: params[:page] || 1, per_page: 12)
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
  def dialog_banner
   #暂时不做
  end
  def dialog_music
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
