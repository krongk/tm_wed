用于在应用中弹出提示窗口： 你还未付款。。。

用处：
1. views/layouts/_s_head.html.erb

  <% unless @site.active? %>
    <link rel="stylesheet" href="/alert/style-switcher.css">
  <% end %>

2. views/layouts/_s_footer.html.erb

  <% unless @site.active? %>     
    <!--Style Switcher-->
    <script src="/alert/style-switcher.js"></script>
    <div id="style-switcher">
      <div id="toggle-switcher"><i class="fa fa-tint"></i></div>
      <h1>你还未付款</h1>
      <a href="/sites/<%= @site.id %>/payment" class="btn btn-danger btn-block">点击这里马上支付</a>
    </div><!--End Style Switcher-->
  <% end %>