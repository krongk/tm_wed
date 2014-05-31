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
  
end
