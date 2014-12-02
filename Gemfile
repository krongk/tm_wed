source 'http://ruby.taobao.org'
#source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.0.2'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'bootstrap-will_paginate'
gem 'font-awesome-sass'
gem 'cancan'
gem 'devise'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'figaro'
gem 'mysql2', '0.3.13'
gem 'rolify'
gem 'simple_form'
gem 'acts-as-taggable-on'
gem 'rqrcode_png'
gem 'useragent'
gem 'alipay', :github => 'chloerei/alipay'
gem 'therubyracer', :platform=>:ruby
gem 'sitemap_generator'

gem 'newrelic_rpm'

#for sortable
gem 'acts_as_list'
#handle the error: couldn't find file 'jquery-ui'
#only used for sortable ui
gem 'jquery-ui-rails' 

#add :git to bugfix open dialog error
gem "ckeditor", :git => "git@github.com:galetahub/ckeditor.git"
#File upload

#gem 'paperclip 4.0' will cause below error:
# => en.activerecord.errors.models.submission_detail.attributes.attachment.spoofed_media_type
gem "paperclip", "~> 3.5.3"
gem 'paperclip-qiniu'
gem 'jquery-fileupload-rails'
#Excel processing
# gem 'roo', '>=1.11.2' 
# gem 'rubyzip', "~> 0.9.9" #fix the error: cannot load such file -- zip/zipfilesystem

#Wizard
gem 'wicked'

#I18n
#gem 'rails-i18n', '~> 4.0.0.pre' # For 4.0.x
#gem 'i18n_yaml_generator'

#Queue
gem 'sidekiq'


#Send Mail
#gem 'mailgun'
gem 'rest_client' #use for sendcloud.org

#Pinyin.t('中国', splitter: '-') => "zhong-guo"
gem 'chinese_pinyin'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_20]
  gem 'capistrano', '~> 3.0.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rails-console'
  gem 'capistrano-rvm', '~> 0.1.1'
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rails_layout'
end
group :development, :test do
  gem 'pry-rails'
  gem 'pry-rescue'
end
