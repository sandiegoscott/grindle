# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  helper_method :current_user

  rescue_from 'Acl9::AccessDenied', :with => :access_denied

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      #logger.info("\n>>>>>>>>> ApplicationController::require_user ...redirecting to #{new_user_session_url}\n")
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
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

  def access_denied
    render :file => File.join(RAILS_ROOT, 'public', '403.html'), :status => 403
  end

  def require_rbuilder
    logger.info("\n>>>>>>>>> ApplicationController::require_rbuilder\n")
    if current_user.is_builder?
      @rbuilder = @current_user
    elsif current_user.is_superintendent? or current_user.is_areamanager?
      begin
        @rbuilder = Rbuilder.find @current_user.rbuilder_id
      rescue
        @rbuilder = nil
      end
    elsif (current_user.is_admin? or current_user.is_inspector?) && session[:rbuilder_id]
      @rbuilder = Rbuilder.find(session[:rbuilder_id])
    else
      redirect_to overview_index_path and return
    end
    return @rbuilder
  end

  def get_rbuilder
    if current_user.is_builder?
      @rbuilder = @current_user
    elsif current_user.is_superintendent? or current_user.is_areamanager?
      begin
        @rbuilder = Rbuilder.find @current_user.rbuilder_id
      rescue
        @rbuilder = nil
      end
    elsif (current_user.is_admin? or current_user.is_inspector?) && session[:rbuilder_id]
      @rbuilder = Rbuilder.find(session[:rbuilder_id])
    end
    logger.info("\n>>>>> /require_rbuilder/  @rbuilder=#{@rbuilder.inspect}\n\n")
    return true
  end

  def make_contact_information(inspector)
    if inspector.group_name.blank?
      @group_name = 'Grindle Inspections'
      @office     = '(800) 123-4567'
      @mobile     = '(333) 333-3333'
      @fax        = '(444) 444-4444'
    else
      @group_name = inspector.group_name
      @office     = inspector.office
      @mobile     = inspector.mobile
      @fax        = inspector.fax
    end
  end

end

