class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper :all
  before_filter :prepare_for_mobile

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  #Override the devise default redirect path
  def after_sign_in_path_for(resource)
    if resource.sites.any?
      sites_path
    else
      new_site_path
    end
  end
  #render 404 error
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def authenticate_auth
    if session[:member].nil?
      authenticate_user!
    else
      current_member
      redirect_to(root_path, notice: '请登录') and return if current_member.nil?
    end
  end

  #obj = site/site_page
  #call: authorize!(@site)
  def authorize!(obj)
    return if current_session.id == 1
    if ![obj.user_id, obj.member_id, obj.try(:site).try(:user_id), obj.try(:site).try(:member_id)].include?(current_session.id)
      raise CanCan::AccessDenied.new('没有权限！' )
    end
  end

  private
    def mobile_device?
      request.user_agent =~ /Mobile|webOS/
    end
    helper_method :mobile_device?
    def prepare_for_mobile
      session[:mobile_param] = params[:mobile] if params[:mobile]
    end

    #bugfix multi submit form
    #http://qiezi.iteye.com/blog/37781
    def check_token
      if session[:__token__] == params[:__token__]  
        session[:__token__] = nil  
        # session.update  
        return true  
      end  
      false  
    end
end
