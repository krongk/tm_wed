json.array!(@resource_musics) do |resource_music|
  json.extract! resource_music, :id, :user_id, :name, :url
  json.url resource_music_url(resource_music, format: :json)
end
