#the member's user_id often = 1
#if the user.id == 1 => we need to use member login session
#
class Member < ActiveRecord::Base
  has_many :sites, -> { order("updated_at DESC") }, :dependent => :destroy
end
