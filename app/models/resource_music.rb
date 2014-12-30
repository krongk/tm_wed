class ResourceMusic < ActiveRecord::Base
  belongs_to :site

  has_attached_file :asset, :path => "musics/:class/:attachment/:id.:extension"
  validates :asset, :attachment_presence => true
  validates_attachment_size :asset, :less_than => 10.megabytes
  validates_attachment_content_type :asset,
    :content_type => [ 'audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ]

  after_create :expire_cache
  after_destroy :expire_cache

  def self.get_my_musics(current_session)
    if current_session.class.to_s == "User"
      where(user_id: current_session.id)
    else
      where(member_id: current_session.id)
    end
  end

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
