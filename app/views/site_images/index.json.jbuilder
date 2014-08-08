json.array!(@site_images) do |site_image|
  json.extract! site_image, :id, :site_page_id, :file, :title, :description
  json.url site_image_url(site_image, format: :json)
end
