class DaysController < ApplicationController
  helper_method :get_all_medication_day_schedules

  def index
    @user = current_user
    @days_taken = @user.user_days_taken
    @medications = @user.medications.all
    @unique_days = @user.unique_user_days
    @taken_by_date = []
    @days_taken.each do |day|
      event = OpenStruct.new(start_time: day.date_taken, medication_schedule:  day.medication_schedule, taken: day.taken)
      @taken_by_date << event
    end
    @taken_by_date
  end

  def get_all_medication_day_schedules(params)
    @user = User.find(session[:user_id])
    @medications = @user.medications
    @current_day = params[:day_of_week]
    @date = params[:date_needed]

    @all_medication_schedules_for_day = []
    @medications.each do |medication|
        @medication_schedules = get_day_schedules(medication_name: medication.name, day_of_week: @current_day)
        @medication_schedules.each do |schedule|
            event = OpenStruct.new(start_time: @date, medication_schedule:  schedule, taken: false)
            @all_medication_schedules_for_day << event
        end
    end
    return @all_medication_schedules_for_day
  end

  def get_day_schedules(params)
    @user = User.find(session[:user_id])
    @medication = @user.medications.find_by(name: params[:medication_name])
    
    @current_day = params[:day_of_week]
    @current_day_schedules = []

    medication_schedules = @medication.medication_schedules.joins(:day_of_week).where("day_of_weeks.name = ? OR day_of_weeks.name = ?", @current_day, "Everyday")
    medication_schedules = medication_schedules.sort_by { |schedule| schedule.time.strftime("%H:%M") }
    medication_schedules.each do |schedule|
        @current_day_schedules << { medication: @medication, schedule: schedule }
    end
  end

  def get_history_day_schedules
    @user = User.find(params[:user_id])
    @medications = @user.medications.all
    @unique_days = @user.unique_user_days
    @date = params[:date_needed]
    @days_taken = @user.user_days_taken.where(date_taken: @date)
    @taken_by_date = []
    @days_taken.each do |day|
      @taken_by_date << {medication_schedule: day.medication_schedule, taken: day.taken}
    end
    @taken_by_date
  end
end