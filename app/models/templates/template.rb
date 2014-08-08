class Templates::Template < ActiveRecord::Base
  self.per_page = 12
  self.table_name = 'templates'

  belongs_to :cate
  has_many :pages, -> { order("position ASC") }, dependent: :destroy
  has_many :themes, dependent: :destroy
  has_many :sites, -> { order("updated_at DESC") }
  has_many :keystores
  
  acts_as_taggable

  def recent_sites(count = 4)
    Site.sites_has_images.where(template_id: self.id).limit(count)
    #Site.where(template_id: self.id).select { |s| s.site_pages.find{|p| p.site_images.any?} }[0..3]
  end

  def recommend_sites(count = 4)
    Site.where(template_id: self.id, status: 'recommend').limit(count)
  end
end