class UsersController < ApplicationController

   def new
    if current_user
      redirect_to home_path
    else
     @user = User.new
    end
   end

   def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "You are registered"
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render 'new'
    end
   end

  

   private

   def user_params
    params.require(:user).permit(:username, :password, :email)
   end
end