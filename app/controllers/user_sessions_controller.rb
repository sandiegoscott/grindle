class UserSessionsController < ApplicationController
  layout "welcome"

  def new
    #logger.info("\n>>>>>>>>> UserSessionsController:new\n")
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to overview_index_path
    else
      render :action => 'new'
    end
  end

  def destroy
    #logger.info(">>>>>>>>>> UserSessionsController::destroy")
    @user_session = UserSession.find(params[:id])
    @user_session.destroy if @user_session
    session.clear
    #logger.info(">>>>>>>>>>   session.clear")
    flash[:notice] = "Successfully logged out."
    redirect_to login_path
  end
end

