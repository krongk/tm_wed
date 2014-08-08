json.array!(@site_pages) do |site_page|
  json.extract! site_page, :id, :user_id, :site_id, :template_page_id, :short_title, :title
  json.url site_page_url(site_page, format: :json)
end
