json.array!(@site_comments) do |site_comment|
  json.extract! site_comment, :id, :site_id, :template_page_id, :name, :mobile_phone, :tel_phone, :email, :qq, :weixin, :weibo, :gender, :birth, :address, :hobby, :content, :content2, :content3, :status, :updated_by, :note
  json.url site_comment_url(site_comment, format: :json)
end
