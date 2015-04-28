class UsersController < ApplicationController

  def show
    @user = User.find_by_friendly_id(params[:id])
  end

end
