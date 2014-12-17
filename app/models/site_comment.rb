class SiteComment < ActiveRecord::Base
  belongs_to :site
  belongs_to :template_page, class_name: 'Templates::Page'

  after_save :expire_cache

  private
    #cache
    def expire_cache
      site = self.site
      cache_paths = []
      cache_paths << File.join(Rails.root, 'public', 'page_cache', 's-' + site.short_title + '.html')
      site.site_pages.each do |site_page|
        cache_paths << File.join(Rails.root, 'public', 'page_cache', "s-#{site.short_title}", "p-#{site_page.short_title}.html")
      end
      cache_paths.each do |path|
        if File.exist?(path)
          FileUtils.rm_rf path
        end
      end
    end
end
