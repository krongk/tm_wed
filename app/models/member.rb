#member 属于非注册用户登录用，通过手机登录或者通过邮件登录，现在只实现了手机登录
class Member < ActiveRecord::Base
  has_many :sites, -> { order("updated_at DESC") }, :dependent => :destroy
end
