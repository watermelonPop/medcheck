class ThemesController < ApplicationController

  # GET /themes/new
  def new
    @theme = Theme.new
  end

  # POST /themes or /themes.json
  def create
    @user = current_user
    @theme = @user.themes.create(name: params[:name], main_background: params[:main_background], schedule_background: params[:schedule_background], medication_background: params[:medication_background], medication_main: params[:medication_main], heading: params[:heading], font: params[:font])
    redirect_to user_path(@user)
  end

  # DELETE /themes/1 or /themes/1.json
  def destroy
    @user = current_user
    @theme = @user.themes.find_by(id: params[:id])
    @theme.destroy
    redirect_to user_path(@user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_theme
      @theme = Theme.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def theme_params
      params.require(:theme).permit(:main_background, :schedule_background, :medication_background, :medication-main, :heading, :font)
    end
end
