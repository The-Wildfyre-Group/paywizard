class UsersController < ApplicationController
  before_filter :correct_user
  before_filter :find_object
  
  def new
    @object = User.new
  end
  
  def create
    @object = User.new(object_params)
    if @object.save
      cookies.permanent[:authentication_token] = @user.authentication_token
      flash[:success] = "Signed up."
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  def show
    
  end
  
  def edit
    
  end
  
  def update
    if @object.update_attributes(object_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end
  
  protected
  
  def object_params
    params.require(:user).permit(:email, :first_name, :middle_name, :last_name)
  end
  
  def find_user
    
  end
  
  
end



