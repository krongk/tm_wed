class SiteComment < ActiveRecord::Base
  belongs_to :site
  belongs_to :template_page, class_name: 'Templates::Page'
end
