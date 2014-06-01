class SController < ApplicationController
  layout 'site'
  include SHelper

  #/s/:site_id(/p-:id)
  def index
    @site = Site.find_by(short_title: params[:site_id])
    @site_page = SitePage.find_by(short_title: params[:id])
    raise "can not found site with params: #{params}" if @site.nil?
    @site_page ||= @site.site_pages.first
    @template = @site.template
    @base_url = get_temp_base_url(@template)
    
    render inline: Templates::Keystore.value_for(@site_page.template_page, 'html'), layout: false
  end
end