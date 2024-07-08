class DayTakensController < ApplicationController
  before_action :set_day_taken, only: %i[update destroy ]

  # POST /day_takens or /day_takens.json
  def create
    @day_taken = DayTaken.new(day_taken_params)
    @day_taken.user_id = current_user.id
    respond_to do |format|
      if @day_taken.save
        format.html { redirect_to day_taken_url(@day_taken), notice: "Day taken was successfully created." }
        format.json { render :show, status: :created, location: @day_taken }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @day_taken.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /day_takens/1 or /day_takens/1.json
  def update
    respond_to do |format|
      if @day_taken.update(day_taken_params)
        format.html { redirect_to day_taken_url(@day_taken), notice: "Day taken was successfully updated." }
        format.json { render :show, status: :ok, location: @day_taken }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @day_taken.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /day_takens/1 or /day_takens/1.json
  def destroy

    respond_to do |format|
      if @day_taken.destroy
        format.html { redirect_to day_takens_url, notice: "Day taken was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to day_takens_url, notice: "Day taken was not destroyed." , status: :unprocessable_entity }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_day_taken
      @day_taken = DayTaken.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def day_taken_params
      params.require(:day_taken).permit(:date, :taken, :user_id, :medication_schedule_id)
    end
end
