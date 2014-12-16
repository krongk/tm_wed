#encoding: utf-8
class SController < ApplicationController
  # layout 'simple' 其实这里不用统一一个layout, 直接render到模板即可
  include SHelper

  caches_page :index 
  
  #/s/:site_id(/p-:id)
  def index
    @site = Site.find_by(short_title: params[:site_id])
    @site_page = SitePage.find_by(short_title: params[:id])
    not_found if @site.nil?
    redirect_to root_path and return unless @site.is_published

    @site_page ||= @site.site_pages.first
    @template = @site.template
    @base_url = get_temp_base_url(@template)
    
    render inline: Templates::Keystore.value_for(@site_page.template_page, 'html'), layout: false
  end
end
