class SitePage < ActiveRecord::Base
  belongs_to :site
  belongs_to :template_page, class_name: 'Templates::Page'
  has_many :site_page_keystores, :dependent => :destroy
  
  has_many :site_images, -> { order("position ASC") }, :dependent => :destroy
  before_create :create_unique_short_title
  after_save :expire_cache
  accepts_nested_attributes_for :site_images, :reject_if => lambda { |a| a[:file].blank? }, :allow_destroy => true

  private
    def create_unique_short_title
      begin
        self.short_title = SecureRandom.hex(3)
      end while self.class.exists?(:short_title => short_title)
    end

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
  