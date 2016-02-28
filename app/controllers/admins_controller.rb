class AdminsController < AuthenticatedController
  before_action :ensure_admin

  def ensure_admin
    unless current_user.admin?
      flash[:notice] = "You do not have access to this area"
      redirect_to root_path 
    end
  end
end