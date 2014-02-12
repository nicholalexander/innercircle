class Admins::AdminsController < SessionsController
  before_filter :authorize_admin
  def index

  end


  def destroy_all
    User.destroy_all
    Photo.destroy_all
    redirect_to admins_path
  end
end
