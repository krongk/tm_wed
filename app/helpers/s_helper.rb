module SHelper
  def get_temp_base_url(template)
    return if template.nil?
    raise "请指定ASSETS_HOST" if ENV['ASSETS_HOST'].nil?
    ENV['ASSETS_HOST'] + ['/', template.base_url, '/'].join('/').squeeze('/')
  end

  #Site URL generate ###########################
  #redirect to first page
  def get_site_url(site)
    return if site.nil?
    get_site_page_url(site.site_pages.first)
  end
  #alias
  def get_url(site_page)
    return if site_page.nil?
    get_site_page_url(site_page)
  end
  #/s/:site_id(/p-:id)
  def get_site_page_url(site_page)
    return if site_page.nil?
    ENV["HOST_NAME"] + "/s/#{site_page.site.short_title}/p-#{site_page.short_title}"
  end
  #Site image generate ###########################
  # => qiniu_image_tag site_image.image.url, :quality => 100, class: 'img-responsive'
  def get_site_images(site)
    SiteImage.joins(:site_page).where("site_pages.site_id = ?", site.id)
  end
  #
  def get_first_site_image_url(site)
    site_images = SiteImage.joins(:site_page).where("site_pages.site_id = ?", site.id)
    return site_images.first.image.url if site_images.any?
    return nil
  end
  #SEO generate ###########################
  def get_seo_title(site_page)
    site_page.title
  end
  def get_seo_meta_keywords(site_page)
    site_page.title
  end
  def get_seo_meta_description(site_page)
    site_page.title
  end

  #SitePageKeystore.value_for(@site_page, 'text1')
  def value_for(obj, attr)
    SitePageKeystore.value_for(obj, attr).try(:html_safe)
  end

end
