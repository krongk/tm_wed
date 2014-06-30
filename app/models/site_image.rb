class SiteImage < ActiveRecord::Base
  belongs_to :site_page

  has_attached_file :image,
                    :path => ":class/:id/:style.:extension",
                    :styles => {:original => '640x960#'} #override the original file
                    #:styles => { :content => '640x960>' } #standerd mobile size: 320*480 480*800 640*960

  validates_attachment_size :image, :less_than => 8.megabytes
  
  #invalid on LG mobile, why?
  #validates_attachment_presence :image

  #update to version 4.0
  #validates_attachment_content_type :image, :content_type => /\Aimage/

  # Explicitly do not validate
  do_not_validate_attachment_file_type :image

  #
  acts_as_list
end
