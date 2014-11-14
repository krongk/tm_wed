class ResourceMusic < ActiveRecord::Base
  belongs_to :site_page

  has_attached_file :asset, :path => "musics/:class/:attachment/:id.:extension"
  validates :asset, :attachment_presence => true
  validates_attachment_size :asset, :less_than => 10.megabytes
  validates_attachment_content_type :asset,
    :content_type => [ 'audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ]

  def self.get_my_musics(current_session)
    if current_session.class.to_s == "User"
      where(user_id: current_session.id)
    else
      where(member_id: current_session.id)
    end
  end
  
end
