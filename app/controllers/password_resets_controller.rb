class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first
    if user && (user.token_set_time  >= User::RESET_TIME)
      @token = user.token
    else
      redirect_to expired_token_path 
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user && (params[:password] == params[:password_confirmation])
      user.password = params[:password]
      user.token = nil
      user.save
      flash[:success] = "Your password has been changed. Please sign in."
      redirect_to sign_in_path
    elsif !(params[:password] == params[:password_confirmation])
      flash[:error] = "Password mismatch"
      redirect_to password_reset_path(user.token)
    else
      redirect_to expired_token_path
    end
  end
end