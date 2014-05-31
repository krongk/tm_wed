class HomeController < ApplicationController

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
  
end
