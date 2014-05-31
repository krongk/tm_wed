json.array!(@sites) do |site|
  json.extract! site, :id, :user_id, :template_id, :short_title, :title, :description, :domain, :status, :is_publiched, :is_comment_show, :updated_by, :note
  json.url site_url(site, format: :json)
end
