class SitePayment < ActiveRecord::Base
  belongs_to :site
  validates  :site_id, :uniqueness => {:scope => [:site_id], :message => "已经存在"}
end
