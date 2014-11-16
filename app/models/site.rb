class Site < ActiveRecord::Base
  self.per_page = 12
  belongs_to :user
  belongs_to :member
  belongs_to :template, class_name: 'Templates::Template'
  belongs_to :theme, class_name: 'Templates::Theme'
  has_one :site_payment, :dependent => :destroy
  has_many :site_pages, :dependent => :destroy
  has_many :resource_musics, :dependent => :destroy
  has_many :site_comments, -> { order("updated_at DESC") }, :dependent => :destroy
  before_create :create_unique_short_title
  after_create :create_site_payment

  scope :sites_has_images, ->{ joins(:site_pages =>:site_images).group("sites.id").order("updated_at DESC") }
  scope :business, -> { where(typo: 'business') }
  scope :personal, -> { where(typo: 'personal') }
  
  #empty
  validates :title, presence: true

  #thief: bad user, bad site -> not allow showing in case and template
  #recommend: good site -> show in template 
  #vip: payed site -> not show in case (if user ask for)
  #vip-recommend -> vip and can show in template examples
  STATUS = %w(vip-recommend vip recommend thief)

  def active?
    ['completed'].include?(self.site_payment.state)
  end

  def vip?
    ['vip', 'vip-recommend'].include?(self.status)
  end

  #bad user, bad site
  def thief?
    ['thief'].include?(self.status)
  end

  private
    def create_unique_short_title
      begin
        self.short_title = SecureRandom.hex(2)
      end while self.class.exists?(:short_title => short_title)
    end

    def create_site_payment
      SitePayment.create!(site_id: id, state: 'opening', price: typo == 'business' ? ENV["PRICE_BUSINESS"] : ENV["PRICE_PERSONAL"])
    end
end
