#encoding: utf-8
#member 属于非注册用户登录用，通过手机登录或者通过邮件登录，现在只实现了手机登录
class Member < ActiveRecord::Base
  has_many :sites, -> { order("updated_at DESC") }, :dependent => :destroy

  validates_presence_of :auth_type, :auth_id
  validates_uniqueness_of :auth_id, scope: [:auth_type]
  validate do
    (m = self.auth_type == 'phone' && !self.auth_id.to_s.strip.match(/^(1(([35][0-9])|(47)|[8][0123456789]))\d{8}$/)) &&
      errors.add(:base, "手机号码格式错误")
  end
end
