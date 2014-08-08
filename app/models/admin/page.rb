class Admin::Page < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  self.per_page = 24

  acts_as_taggable

  validates :channel, :title, :short_title, presence: true
  validates :short_title, format: { with: /\A[a-zA-Z0-9-]+\z/,
    message: "名称简写只能包括字母数字和横线" }

  def short_description(count = 50)
    self.description.to_s.truncate(count)
  end
  
  def format_date
    self.updated_at.strftime("%Y-%m-%d") unless self.updated_at.nil?
  end

  def thumb_image_path
    self.image_path.sub(/content/, 'thumb')
  end

  #最近新闻
  #params: 
  # => typo = ['article', 'image', 'product']
  # => channel =[ channel.short_title, ]
  # => properties =[recommend, top, hot]
  #eg: Admin::Page.recent(12, :typo => 'product',  :rand => true)
  #    Admin::Page.recent(10, :channel => 'product-bed')
  def self.recent(count = 10, options = {})
    queries     = []
    conditions  = []
    if options[:channel].present?
      queries     << 'admin_channels.short_title = ?'
      conditions  << options[:channel]
    end
    if options[:typo].present?
      queries     << 'admin_channels.typo = ?'
      conditions  << options[:typo]
    end
    if options[:properties].present?
      queries     << 'admin_pages.properties = ?'
      conditions  << options[:properties]
    end
    conditions.unshift(queries.join(' AND '))
    return Admin::Page.joins(:channel).where(conditions).order("updated_at DESC").limit(count)
  end

  #搜索
  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      all
    end
  end

end
