class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @medications = @user.medications
  end
end
