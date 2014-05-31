module SiteStepsHelper

  def get_wizard_html(site)
    html = []
    site_pages = site.site_pages.order("id ASC")
    page_size = site_pages.size
    html << %{<ol class="wizard-progress" data-steps="#{ page_size + 1}">}
    site_pages.each_with_index do |site_page, index|
      step_name = 'site_page_' + site_page.id.to_s
      html << %{<!----><li class="#{past_step?(step_name) ? 'done' : (current_step?(step_name) ? 'current' : '')}">}
      html << %{<span>#{site_page.title}</span>}
      html << %{<i></i>} if index == 0 || index == page_size - 1
      html << %{</li>}
    end
    html << %{<!----><li><span>完成</span><i></i></li>}
    html << "</ol>"
    html.join.html_safe
  end
end
