class HomeController < ApplicationController
  layout :resolve_layout

  caches_page :index, :templates, :template, :pricing, :post
  
  def index
    #render text: params and return
  end

  def templates
    @cates = Templates::Cate.all
    @templates = Templates::Template.where(is_published: true).order("updated_at DESC").paginate(page: params[:page] || 1, per_page: 12)
  end

  def template
    @template = Templates::Template.find(params[:id])
  end

  def case
    @templates = Templates::Template.where("cate_id in (1,2)").order("updated_at DESC")
    @last_template = @templates.pop #use for filter style
    @sites = Site.sites_has_images.where("sites.status IS NULL OR sites.status not in('vip', 'thief')").paginate(page: params[:page] || 1, per_page: 12)
  end

  #案例精选
  #params: personal, business
  def top
    if params[:q] == 'p' || params[:q] == 'personal'
      @sites = Site.joins(:site_payment).personal.where("sites.status in('vip', 'vip-recommend') OR site_payments.state = 'completed'").order("id desc").page(params[:page])
    elsif params[:q] == 'b' || params[:q] == 'business'
      @sites = Site.joins(:site_payment).business.where("sites.status in('vip', 'vip-recommend') OR site_payments.state = 'completed'").order("id desc").page(params[:page])
    else
      @sites = Site.joins(:site_payment).where("sites.status in('vip', 'vip-recommend') OR site_payments.state = 'completed'").order("id desc").page(params[:page])
    end
  end

  #高级定制案例
  def biz
    @sites = BizSite.order("id DESC").page(params[:page])
  end

  def vip
    if current_session
      redirect_to new_site_path(template_id: params[:template_id], typo: 'business')
    end

    @show_contact = false #this var is for turn off footer contact form, used in layouts/_contact.html.erb
    @template = Templates::Template.find_by(id: params[:template_id])
    #render text: params and return
  end

  def pricing

  end

  def search

  end

  #post list
  def blog
    @posts = Admin::Page.joins(:channel).where("admin_channels.short_title = ?", 'wedxt').order("updated_at DESC").paginate(page: params[:page], per_page: 9)
  end

  def post
    @post = Admin::Page.find_by(short_title: params[:id])
  end

  def video
    @posts = Admin::Page.joins(:channel).where("admin_channels.short_title = ?", 'video').order("updated_at DESC").paginate(page: params[:page], per_page: 9)
  end
  
  #大转盘需要调用的action: 返回json数据，给js调用
  #params: site_page_id, key
  def zhuanpan_json
    # status 值：
    # 0 -> 亲，活动还未开始啦!
    # 1 -> 活动进行中: 抽奖并中奖
    # 2 -> 活动进行中：抽奖未中奖
    # 3 -> 今日奖品已经领完，明天继续哦！
    # 4 -> 亲，活动已经结束啦!

    # goods_id: 
    # 8个值分别对应8格转盘的8个格子，其中3，7格为默认未中奖格，其他格为有奖格
    # 1 -> 奖品1
    # 2 -> 奖品2
    # 3 -> 未中奖
    # 4 -> 奖品3
    # 5 -> 奖品4
    # 6 -> 奖品5
    # 7 -> 未中奖
    # 8 -> 奖品6
    @site_page = SitePage.find(params[:id])

    #状态获取
    status = case SitePageKeystore.value_for(@site_page, 'open_toggle')
    when '活动进行中'
      2
    when '活动未开始'
      0
    when '活动已结束'
      4
    else
      2
    end

    #获取用户设定的奖品总数
    prize_obj = SitePageKeystore.get(@site_page.id, 'prize_count')
    prize_count = prize_obj.value.to_i || 100
  
    #获取中奖次数
    coupon_obj = SitePageKeystore.get(@site_page.id, 'coupon_count')
    if coupon_obj.nil?
      key = CommonKey.get('coupon_count')
      CommonKey.put('coupon_count', 0) if key.nil?
      SitePageKeystore.put(@site_page.id, 'coupon_count', 0)
      coupon_obj = SitePageKeystore.get(@site_page.id, 'coupon_count')
    end
    coupon_count = coupon_obj.value.to_i

    status  = 3 if coupon_count >= prize_count #奖品已完

    #binding.pry
    puts "-----------> #{status} --> #{prize_count} --> #{coupon_count}"

    # 奖项数组 
    # 是一个二维数组，记录了所有本次抽奖的奖项信息， 
    # 其中id表示中奖等级，prize表示奖品，v表示中奖概率。 
    # 注意其中的v必须为整数，你可以将对应的 奖项的v设置成0，即意味着该奖项抽中的几率是0， 
    # 数组中v的总和（基数），基数越大越能体现概率的准确性。 
    # 本例中v的总和为100，那么平板电脑对应的 中奖概率就是1%， 
    # 如果v的总和是10000，那中奖概率就是万分之一了。 
    prize_hash = {   
      0 => {'id'=>1,'prize'=> SitePageKeystore.value_for(@site_page, 'good1'),'v'=>1},   
      1 => {'id'=>2,'prize'=> SitePageKeystore.value_for(@site_page, 'good2'),'v'=>2},  
      2 => {'id'=>8,'prize'=> SitePageKeystore.value_for(@site_page, 'good3'),'v'=>5},
      3 => {'id'=>4,'prize'=> SitePageKeystore.value_for(@site_page, 'good4'),'v'=>10},  
      4 => {'id'=>5,'prize'=> SitePageKeystore.value_for(@site_page, 'good5'),'v'=>12},  
      5 => {'id'=>6,'prize'=> SitePageKeystore.value_for(@site_page, 'good6'),'v'=>20},
      6 => {'id'=>3,'prize'=> '没有抽中，感谢参与','v'=>20},
      7 => {'id'=>7,'prize'=> '没有抽中，没准下次能抽到哦','v'=>30},  
    }
    
    # 每次前端页面的请求，PHP循环奖项设置数组， 
    # 通过概率计算函数get_rand获取抽中的奖项id。 
    # 将中奖奖品保存在数组$res['yes']中， 
    # 而剩下的未中奖的信息保存在$res['no']中， 
    # 最后输出json个数数据给前端页面。 
    arr = {}
    prize_hash.each_pair do |key, val|
      arr[val['id']] = val['v']
    end
    rid = get_rand(arr) #根据概率获取奖项id
    coupon = prize_hash[rid - 1] #抽中的奖项
    if status == 2 && ![3, 7].include?(coupon['id']) #中奖了
      SitePageKeystore.put(@site_page.id, 'coupon_count', coupon_count + 1)
      status = 1
    end

    if status == 1 #中奖了
      render json: {status: status, goods_id: coupon['id'], message: coupon['prize'], Coupon: {grade: coupon['id']}}
    else #没中奖
      render json: {status: status}
    end
  end

  # 
  #  经典的概率算法， 
  #  $proArr是一个预先设置的数组， 
  #  假设数组为：array(100,200,300，400)， 
  #  开始是从1,1000 这个概率范围内筛选第一个数是否在他的出现概率范围之内，  
  #  如果不在，则将概率空间，也就是k的值减去刚刚的那个数字的概率空间， 
  #  在本例当中就是减去100，也就是说第二个数是在1，900这个范围内筛选的。 
  #  这样 筛选到最终，总会有一个数满足要求。 
  #  就相当于去一个箱子里摸东西， 
  #  第一个不是，第二个不是，第三个还不是，那最后一个一定是。 
  #  这个算法简单，而且效率非常 高， 
  #  关键是这个算法已在我们以前的项目中有应用，尤其是大数据量的项目中效率非常棒。 
  #  pro_hash = {id => v, 1 => 1, 2 => 30} 
  def get_rand(pro_hash)
      result = nil
      #概率数组的总概率精度  
      pro_sum = pro_hash.values.inject{|sum,x| sum + x }
      #概率数组循环
      pro_hash.each_pair do |key, pro_cur|
        rand_num = 1 + rand(pro_sum)
        if rand_num <= pro_cur
          result = key
          break
        else
          pro_sum -= pro_cur
        end
      end
      result
  end

  #用于page_steps中对话框扩展： 选择封面、选择音乐。
  #这些特殊的内容，不放在tm_admin中。

  #在弹出窗口的链接中如果想要显示该页面上传的图片，在需要传递site_page参数，用于获取site_page下面的图片列表：
  #<a data-target="#bannerModal" data-toggle="modal" href="/home/dialog_banner?site_page_id=<%=@site_page.id%>">
  # url: '/home/dialog_banner?site_page_id=' + @site_page.id.to_s
  def dialog_banner
   site_page = SitePage.find_by(id: params[:site_page_id])
   @site_images = site_page.site_images if site_page
   @site_images ||= []
  end

  def dialog_music
    @musics = ResourceMusic.where("user_id is null and member_id is null").order("updated_at DESC").page(params[:page])
    @my_musics = ResourceMusic.get_my_musics(current_session)
  end

  private
    def resolve_layout
      case action_name
      when /dialog_.*/ 
        false
      else
        "application"
      end
    end

end
