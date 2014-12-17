class SiteImage < ActiveRecord::Base
  belongs_to :site_page
  default_scope order("position ASC")
  
  has_attached_file :image,
                    :path => ":class/:id/:style.:extension",
                    :styles => {:original => '1000x1000>'} #crop on each show
                    #:styles => {:original => '640x960#'} #override the original file
                    #:styles => { :content => '640x960>' } #standerd mobile size: 320*480 480*800 640*960

  validates_attachment_size :image, :less_than => 8.megabytes
  
  #invalid on LG mobile, why?
  #validates_attachment_presence :image

  #update to version 4.0
  validates_attachment_content_type :image, :content_type => /\Aimage/

  # Explicitly do not validate
  #do_not_validate_attachment_file_type :image

  #sort by position
  acts_as_list :scope => :site_page

  #init position
  before_create :assign_position
  after_create :expire_cache
  after_destroy :expire_cache

  private
    def assign_position
      last_site_image = SiteImage.where(site_page_id: self.site_page_id).order("position ASC").pop
      if last_site_image.nil?
        self.position = 1
      else
        self.position = last_site_image.position.to_i + 1
      end
    end

    #cache
    def expire_cache
      site = self.site_page.site
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

# show image in your view
#   <%= qiniu_image_tag @image.file.url, :thumbnail => '300x300>', :quality => 80 %>
#   or
#   <%= image_tag qiniu_image_path(@image.file.url, :thumbnail => '300x300>', :quality => 80) %>

#crop to 960
  # <%= image_tag qiniu_image_path(@picture.asset.url,  
  #   thumbnail: 'x960',
  #   crop: '!640x-0a0',
  #   quality: 85
  # )
  # %>
