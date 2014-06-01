class SitePage < ActiveRecord::Base
  belongs_to :site
  belongs_to :template_page, class_name: 'Templates::Page'
  has_many :site_page_keystores, :dependent => :destroy
  has_many :site_images, -> { order("position ASC") }, :dependent => :destroy
  before_create :create_unique_short_title

  accepts_nested_attributes_for :site_images, :reject_if => lambda { |a| a[:file].blank? }, :allow_destroy => true

  private
    def create_unique_short_title
      begin
        self.short_title = SecureRandom.hex(3)
      end while self.class.exists?(:short_title => short_title)
    end
end
  