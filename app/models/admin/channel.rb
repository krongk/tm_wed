class Admin::Channel < ActiveRecord::Base
  belongs_to :user
  has_many :pages, dependent: :destroy
  has_many :children, class_name: "Admin::Channel",
                          foreign_key: "parent_id",
                          dependent: :destroy
  belongs_to :parent, class_name: "Admin::Channel"

  TYPOS = %w[article image product]
  
  acts_as_taggable

end
