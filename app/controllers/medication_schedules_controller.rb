class MedicationSchedulesController < ApplicationController
  before_action :set_medication_schedule, only: %i[ show destroy ]
  skip_before_action :require_login, only: [:take_closest_schedule]
  skip_before_action :verify_authenticity_token, only: [:take_closest_schedule]
  # GET /medication_schedules or /medication_schedules.json
  def index
    @user = current_user
    @medication = @user.medications.find_by(id: params[:medication_id])
    if @medication
      @medication_schedules = @medication.medication_schedules
    end
  end

  # GET /medication_schedules/new
  def new
    @user = current_user
    @medication = @user.medications.find_by(id: params[:medication_id])
    @medication_schedule = MedicationSchedule.new
  end

  # POST /medication_schedules or /medication_schedules.json
  def create
    @user = current_user
    @medication = @user.medications.find_by(id: params[:medication_id])
    @medication_schedule = @medication.medication_schedules.build(medication_schedule_params)


    respond_to do |format|
      if @medication_schedule.save
        format.html { redirect_to new_user_medication_medication_schedule_path(user_id: @user.id, medication_id: @medication.id), notice: "Medication schedule for " + @medication.name + " was successfully created." }
        format.json { render :show, status: :created, location: @medication_schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medication_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medication_schedules/1 or /medication_schedules/1.json
  def destroy
    @user = current_user
    @medication = @user.medications.find_by(id: params[:medication_id])
    @medication_schedule = @medication.medication_schedules.find_by(id: params[:id])
    @medication_schedule.destroy!

    respond_to do |format|
      format.html { redirect_to user_medication_medication_schedules_path(user_id: @user.id, medication_id: @medication.id), notice: "Medication schedule for " + @medication.name + " was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def get_day_schedules
    @user = current_user
    @medication = @user.medications.find_by(id: params[:medication_id])
    
    @current_day = params[:day_of_week]
    @current_day_schedules = []
    medication_schedules = @medication.medication_schedules.where("day_of_week = ? OR day_of_week = ?", @current_day, 'Everyday')
    medication_schedules = medication_schedules.sort_by { |schedule| schedule.time.strftime("%H:%M") }
    medication_schedules.each do |schedule|
        @current_day_schedules << { medication: @medication, schedule: schedule }
    end
  end

  def get_today_schedules
    @user = current_user
    
    @current_day = Date.today.strftime("%A")
    

    @medications = @user.medications
    total_schedules = []
    @medications.each do |medication|
      medication_schedules = medication.medication_schedules.where("day_of_week = ? OR day_of_week = ?", @current_day, 'Everyday')
      medication_schedules.each do |schedule|
        total_schedules << schedule
      end
    end
    @current_day_schedules = []
    medication_schedules = total_schedules.sort_by { |schedule| schedule.time.strftime("%H:%M") }
    medication_schedules.each do |schedule|
        @current_day_schedules << { medication: schedule.medication, schedule: schedule }
    end
  end

  def take_closest_schedule
      @user = User.find_by(id: params[:user_id])
      @current_day = Date.today.strftime("%A")
      @medication = @user.medications.find_by(name: params[:medication_name])
      @medication_schedules = @medication.medication_schedules.where("day_of_week = ? OR day_of_week = ?", @current_day, "Everyday")
      current_time = Time.now
      closest_schedule = @medication_schedules.min_by do |schedule|
        # Calculate the absolute difference in seconds between the schedule time and current time
        (schedule.time.seconds_since_midnight - current_time.seconds_since_midnight).abs
      end
    
      closest_schedule.update(taken: true)
      @current_day_taken = DayTaken.find_by(date: Date.today, medication_schedule_id: closest_schedule.id)
      if @current_day_taken
              @current_day_taken.update(taken: true)
      else
              DayTaken.create(date: Date.today, taken: true, user_id: @user.id, medication_schedule_id: closest_schedule.id)
      end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medication_schedule
      @medication_schedule = MedicationSchedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def medication_schedule_params
      params.require(:medication_schedule).permit(:time, :day_of_week, :taken)
    end
end
