module ApplicationHelper
  SPECIAL_SYMBO_REG = /(,|;|\||，|；|。|、| )/

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def title(page_title)
    content_for(:title){ page_title}
    return page_title
  end
  def meta_keywords(meta_keywords)
    content_for(:meta_keywords){ meta_keywords}
  end
  def meta_description(meta_description)
    content_for(:meta_description){ meta_description}
  end
  def content(item_content)
    content_for(:content){ raw item_content }
  end

  def get_date(date)
    date.strftime("%Y-%m-%d")
  end

  #Maybe image storeed in another host
  #demo_img like: "assets/previews/demo.png,assets/previews/demo2.png,assets/previews/mobile.png"
  #need to parse to: templates/simple_one/assets/previews/demo.png
  #eg: get_host_image_list(@template, 'domo_img')
  def get_host_image_list(obj, img_col)
    image_list = []
    puts obj.send(img_col)
    puts obj.class

    case obj.class.to_s
    when "Templates::Template"
      obj.send(img_col).to_s.split(SPECIAL_SYMBO_REG).each do |img|
        puts img
        next unless img =~ /\.(jpg|png|gif|jpeg)/i
        image_list << [ENV["ASSETS_HOST"], obj.base_url, img].join('/')
      end
    when "Templates::Page"
      obj.send(img_col).to_s.split(SPECIAL_SYMBO_REG).each do |img|
        puts img
        next unless img =~ /\.(jpg|png|gif|jpeg)/i
        image_list << [ENV["ASSETS_HOST"], obj.template.base_url, img].join('/')
      end
    else
    end
    return image_list
  end

end
