class SessionsController < ApplicationController

  def new
    if current_user
      redirect_to root_path
    end
  end

  def create
    user = User.where(email: params[:email]).first 
    if user && user.authenticate(params[:password])
      cookies.permanent[:authentication_token] = user.authentication_token
      redirect_to root_path
    else
      flash[:error] = "Email or password is incorrect."
      redirect_to :back
    end
  end

  def show; end

  def destroy
    cookies.delete(:authentication_token)
    redirect_to root_url
  end 
  
  
end