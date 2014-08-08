#xj:
# 1. config this file
# 2. run test: rake sitemap:refresh:no_ping
# 3. on production run: rake sitemap:refresh

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.wedxt.com"

SitemapGenerator::Sitemap.create do
  
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily' 
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add templates_path, :priority => 0.8, :changefreq => 'weekly'
  #NameError: uninitialized constant SitemapGenerator::Templates::Template
  (1..5).each do |id|
    add template_path(id), :priority => 0.8, :changefreq => 'weekly'
  end

  add case_path, :priority => 0.8, :changefreq => 'daily'
  
  add blog_path, :priority => 0.8, :changefreq => 'weekly'
  Admin::Page.joins(:channel).where("admin_channels.short_title = ?", 'wedxt').order("updated_at DESC").find_each do |post|
    add post_path(post.short_title), :lastmod => post.updated_at, :priority => 0.6, :changefreq => 'monthly'
  end
  
  add pricing_path, :priority => 0.8, :changefreq => 'weekly'
  add vip_path, :priority => 0.8, :changefreq => 'weekly'

  Site.find_each do |site|
    add "/sites/#{site.id}/preview", :lastmod => site.updated_at, :priority => 0.4, :changefreq => 'monthly'
    add "/s-#{site.short_title}", :lastmod => site.updated_at, :priority => 0.6, :changefreq => 'monthly'
    site.site_pages.order("id asc").each_with_index do |page, index|
      next if index == 0
      add "/s-#{site.short_title}/p-#{page.short_title}", :lastmod => site.updated_at, :priority => 0.2, :changefreq => 'monthly'
    end
  end
end
