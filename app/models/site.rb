class Site < ActiveRecord::Base
  belongs_to :user
  belongs_to :member
  belongs_to :template, class_name: 'Templates::Template'
  has_many :site_pages, :dependent => :destroy
  has_many :site_comments, -> { order("updated_at DESC") }, :dependent => :destroy
  before_create :create_unique_short_title

  #empty
  validates :title, presence: true

  private
    def create_unique_short_title
      begin
        self.short_title = SecureRandom.hex(2)
      end while self.class.exists?(:short_title => short_title)
    end
end
