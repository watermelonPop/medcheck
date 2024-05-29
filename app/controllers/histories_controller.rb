class HistoriesController < ApplicationController
  def index
   @user = current_user
    @days_taken = @user.day_takens
    @medications = @user.medications.all
    @unique_days = @user.day_takens.uniq.pluck(:date)
  end

  def new
  end

  def show
    @user = current_user
    @medications = @user.medications.all
    @unique_days = @user.unique_user_days
    @taken_by_date = []
    @days_taken.each do |day|
      @taken_by_date << {id: day.id, medication_schedule: day.medication_schedule, taken: day.taken}
    end
    @taken_by_date
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def search
  end

  def get_history_day_schedules
    @user = current_user
    @date = params[:date_needed]
    @days_taken = @user.day_takens.where("date = ?", params[:date_needed])

    if Date.parse(@date) > Date.today
      temp_day_taken = Struct.new(:date, :taken, :medication_schedule_id, :time)
      @days_taken = []
      day_of_week = Date.parse(@date).strftime("%A")
      @medications = @user.medications.all
      if @medications
        puts "MEDICATIONS EXISTS"
        @medications.each do |medication|
          schedules = medication.medication_schedules.where("day_of_week = ? OR day_of_week = ?", day_of_week, "Everyday")
          if schedules
            puts "SCHEDULES EXISTS"
            schedules.each do |schedule|
              @days_taken << temp_day_taken.new(date: Date.parse(@date), taken: false, medication_schedule_id: schedule.id, time: schedule.time)
            end
          end
        end
      end
      @days_taken = @days_taken.sort_by { |item| item.time.strftime("%H:%M") }
      puts "DAYS : " + @days_taken.to_s
    end
  end

  def get_day_schedules
    @user = current_user
    @medication = @user.medications.find_by(id: params[:medication_id])
    
    @current_day = params[:day_of_week]
    @current_day_schedules = []
    medication_schedules = @medication.medication_schedules.where("day_of_week = ? OR day_of_week = ?", @current_day, 'Everyday')
    puts "SCHEDULES: " + medication_schedules.to_s
    medication_schedules = medication_schedules.sort_by { |schedule| schedule.time.strftime("%H:%M") }
    medication_schedules.each do |schedule|
        @current_day_schedules << { medication: @medication, schedule: schedule }
    end
  end
end
