class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
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

end
