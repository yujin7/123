class ApplicationController < ActionController::Base

  protect_from_forgery
  helper_method :current_user_session, :current_user
  before_filter :set_per_page
  layout :get_layout

  helper_method :conver 
  
  def get_layout
    if current_user
      return 'application'
    else
      return 'general'
    end
  end

  # Will convert 24 hrs time to 12 hrs time. EX: convert('13') returns '1 PM'
  def conver tym
    if tym == '00'
      tym = '12' + 'AM'
    elsif tym == '12'
      tym = '12' + 'PM'
    else
      tym = (tym.to_i > 12) ? ((tym.to_i - 12).to_s + 'PM') : (tym + 'AM')
    end
  end

  def is_admin
    if current_user.is_admin?
      return true
    else
      flash[:error] = "You don't have permission to perform this operation"
      redirect_to root_url
      return false
    end
  end

  def has_permission?
    if current_user.is_admin?
      return true
    else
      roles = current_user.roles
      if !roles.empty?
        role_ids = roles.map{|r| r.id}.join(',') if !roles.empty?
        if params[:action] == 'index' or params[:action] == 'show'
          action_name = 'view'
        elsif params[:action] == 'new' or params[:action] == 'create'
          action_name = 'create'
        elsif params[:action] == 'edit' or params[:action] == 'update'
          action_name = 'edit'
        elsif params[:action] == 'destroy'
          action_name =  'delete'
        else
          action_name = 'no_perm'
        end
        permission_id = Permission.find_by_name(action_name).id if action_name != 'no_perm'
        tab_id = ApplicationTab.find_by_name(params[:controller]).id
        permission_roles = PermissionRole.find(:all, :conditions => ["role_id in (#{role_ids}) and permission_id = ? and tab_id = ?",permission_id,tab_id]) if !role_ids.to_s.blank?
        if action_name == 'no_perm' or permission_roles.empty?
          flash[:error] = "You don't have permission to perform this operation on #{params[:controller]}."
          redirect_to root_url
        else
          return true
        end
      else
        flash[:error] = "You don't have roles assigned to perform any operation."
        redirect_to root_url
      end
    end
  end
  
  private
  def current_user_session
    logger.debug "ApplicationController::current_user_session"
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
   
  def current_user
    logger.debug "ApplicationController::current_user"
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
   
  def require_user
    logger.debug "ApplicationController::require_user"
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end
   
  def require_no_user
    logger.debug "ApplicationController::require_no_user"
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end
   
  def store_location
    session[:return_to] = request.request_uri
  end
   
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def set_per_page
    @per_page = session[:per_page] = params[:per_page] ? params[:per_page] : (session[:per_page] ? session[:per_page] : 10)
  end
  
end