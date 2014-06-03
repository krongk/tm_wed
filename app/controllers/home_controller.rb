class HomeController < ApplicationController
  layout :resolve_layout

  def index
    #render text: params and return
  end

  def portfolio
    @templates = Templates::Template.where(true).order("updated_at DESC").page(params[:page] || 1)
  end

  def case

  end

  def pricing

  end

  def search

  end

  #post list
  def blog
    @posts = Admin::Page.joins(:channel).where(true).page(params[:page])
  end

  def post
    @post = Admin::Page.find_by(short_title: params[:id])
  end
  
  #用于page_steps中对话框扩展： 选择封面、选择音乐。
  #这些特殊的内容，不放在tm_admin中。
  def dialog_banner
   #暂时不做
  end

  private
    def resolve_layout
      case action_name
      when "dialog_banner"
        "simple"
      else
        "application"
      end
    end

end
