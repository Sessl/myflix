class UsersController < ApplicationController

  before_filter :require_user, only: [:show]

  def new
    if current_user
      redirect_to home_path
    else
     @user = User.new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])

    if result.successful?
      session[:user_id] = @user.id
      flash[:notice] = "You are registered"
      redirect_to home_path
    else
      flash[:danger] = result.error_message
      render :new
    end

  end

  def new_with_invitation_token 
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render 'new'
    else
      redirect_to expired_token_path
    end
  end
   
  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email)
  end

  
end