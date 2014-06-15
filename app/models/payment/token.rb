class Payment::Token < ActiveRecord::Base
  scope :active, -> { where status: 'active' }
  scope :inactive, -> { where status: 'inactive' }
  
end
