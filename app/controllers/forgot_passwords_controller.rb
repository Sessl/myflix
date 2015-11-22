class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
  	@user = User.where(email: params[:email]).first
  	if @user
      @user.generate_password_reset_token
  		MyflixMailer.send_forgot_password(@user).deliver
  		redirect_to forgot_password_confirmation_path
  	else
  	  flash[:error] = params[:email].blank? ? "Email cannot be blank." : "There is no user with that email in the system."
  	  redirect_to forgot_password_path
    end
  end

#removing the confirm action since confirm.html.haml is a static page. This way Rails will automatically render the page.
 # def confirm
 # end
end