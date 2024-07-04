class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @medications = @user.medications
  end

  def set_current_theme
    @user = current_user
    @user.update(current_theme: @user.themes.find_by(id: params[:theme_id]))
    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.js  { location.reload(); }
    end
  end
end
