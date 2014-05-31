class SiteStepsController < ApplicationController
  include Wicked::Wizard
  prepend_before_filter :set_steps
  before_filter :set_site

  #http://localhost:3000/sites/7/site_steps/site_page_11
  #{"action"=>"show", "controller"=>"site_steps", "site_id"=>"7", "id"=>"site_page_11"}
  def show
    #render text: params and return
    begin
      render_wizard
    rescue => ex
      #default render to site_steps/show.html.erb
      if ex.message =~ /site_page_(\d+)/i
        @site_page = SitePage.find($1)
        @site_images = SiteImage.where(site_page_id: @site_page.id).order("position ASC").page(params[:page] || 1)
      else
        raise
      end
    end
  end
  
  #only store the params[:site_page]
  #{"utf8"=>"✓", "_method"=>"patch", "authenticity_token"=>"Luk=", "site_page"=>{"name"=>"afe", "sex"=>"男"}, 
  #"commit"=>"保存", "action"=>"update", "controller"=>"site_steps", "site_id"=>"14", "id"=>"site_page_32"}
  def update
    #render text: params and return
    @site_page = SitePage.find(params[:id].sub(/site_page_/, ''))
    @site_images = SiteImage.where(site_page_id: @site_page.id).order("position ASC").page(params[:page] || 1)

    #store customer's input value
    if params[:site_page]
      params[:site_page].each_pair do |key, val|
        next if val.blank?
        SitePageKeystore.put(@site_page.id, key, val)
      end
    end
    render_wizard @site_page
  end
  
private

  def redirect_to_finish_wizard(params)
    redirect_to @site, notice: t('notice.site_steps.finished')
  end

  def set_site
    @site = Site.find(params[:site_id])
  end

  def set_steps
    @site = Site.find(params[:site_id])
    site_page_ids = @site.site_pages.order("id ASC").map{|sp| 'site_page_' + sp.id.to_s}
    self.steps = site_page_ids
  end

end
