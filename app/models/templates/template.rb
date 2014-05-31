class Templates::Template < ActiveRecord::Base
  self.per_page = 12
  self.table_name = 'templates'

  belongs_to :cate
  has_many :pages, -> { order("position ASC") }
  has_many :themes
  has_many :sites, -> { order("updated_at DESC") }
  has_many :keystores
  
  acts_as_taggable
end
