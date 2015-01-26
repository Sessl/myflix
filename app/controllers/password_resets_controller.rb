class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first
    if user && (user.token_set_time  >= 2.hours.ago)
      @token = user.token
    else
      redirect_to expired_token_path 
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user 
      user.password = params[:password]
      user.token = nil
      user.save
      flash[:success] = "Your password has been changed. Please sign in."
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end
end