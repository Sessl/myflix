class SessionsController < ApplicationController

def new
  redirect_to home_path if current_user
end

def create
  @user = User.find_by(email: params[:email]) #changed local variable user to @user so that rspec test expect(assigns(:user)).to eq(penny) passes

  if @user && @user.authenticate(params[:password])
    session[:user_id] = @user.id
    flash[:notice] = "You are logged in!"
    redirect_to current_user.admin? ? new_admin_add_video_path : home_path
  else
    flash[:danger] = "There is something wrong with your username or password"
    redirect_to sign_in_path
  end
end

def destroy
  session[:user_id] = nil
  flash[:notice] = "You've successfully logged out!"
  redirect_to root_path
end
    
end