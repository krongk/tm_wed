class Site < ActiveRecord::Base
  belongs_to :user
  belongs_to :member
  belongs_to :template, class_name: 'Templates::Template'
  belongs_to :theme, class_name: 'Templates::Theme'
  has_one :site_payment, :dependent => :destroy
  has_many :site_pages, :dependent => :destroy
  has_many :site_comments, -> { order("updated_at DESC") }, :dependent => :destroy
  before_create :create_unique_short_title
  after_create :create_site_payment

  #empty
  validates :title, presence: true

  #PAYMENT_STATUS = ['FREE', 'PENDING', 'FAILURE', 'SUCCESS', 'EXPIRED']
  def active?
    ['FREE', 'SUCCESS'].include?(self.site_payment.status)
  end

  private
    def create_unique_short_title
      begin
        self.short_title = SecureRandom.hex(2)
      end while self.class.exists?(:short_title => short_title)
    end

    def create_site_payment
      SitePayment.create!(site_id: self.id, status: ENV["DEFAULT_PAYMENT_STATUS"], price: ENV["DEFAULT_PAYMENT_PRICE"])
    end
end
