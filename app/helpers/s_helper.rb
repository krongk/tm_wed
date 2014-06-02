module SHelper
  #
  def get_temp_base_url(template)
    return if template.nil?
    raise "请指定ASSETS_HOST" if ENV['ASSETS_HOST'].nil?
    URI.join(ENV['ASSETS_HOST'], ['/', template.base_url, '/'].join('/').squeeze('/'))
  end
  #comment url/music url
  # temp_dir = comment => /public/templates/comment
  #call: get_base_url('comment', 'theme_one')
  def get_base_url(temp_dir, theme = nil)
    return if temp_dir.nil?
    raise "请指定ASSETS_HOST" if ENV['ASSETS_HOST'].nil?
    URI.join(ENV['ASSETS_HOST'], ['/', 'templates', temp_dir, theme, '/'].join('/').squeeze('/'))
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
    if site_page.template_page.position == 1
      [ENV["HOST_NAME"], "s-#{site_page.site.short_title}"].join('/')
    else
      [ENV["HOST_NAME"], "s-#{site_page.site.short_title}", "p-#{site_page.short_title}"].join('/')
    end
  end
  #Site image generate ###########################
  # => qiniu_image_tag site_image.image.url, :quality => 100, class: 'img-responsive'
  def get_site_images(site)
    SiteImage.joins(:site_page).where("site_pages.site_id = ?", site.id)
  end
  #
  def get_first_site_image_url(site)
    site_iamges = SiteImage.joins(:site_page).where("site_pages.site_id = ?", site.id).limit(1)
    site_iamges.first.try(:image).try(:url)
  end
  #
  def get_site_page_url_by_title(site, title)
    site_page = site.site_pages.find{|s| s.title == title}
    get_site_page_url(site_page)
  end

  #获取应用的菜单
  def get_menu(site)
    site.site_pages.order("id ASC")
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
  def value_for(obj, name, attr={})
    SitePageKeystore.value_for(obj, name, attr).try(:html_safe)
  end

end
