class MedicationSchedulesController < ApplicationController
    require_dependency 'days_taken'

    def create
        @user = current_user
        @medication = @user.medications.find_by(name: params[:medication_name])
        puts "CREATE PARAMS: " + medication_schedule_params.to_s
        @medication_schedule = @medication.medication_schedules.build(medication_schedule_params)

        respond_to do |format|
            if !@medication_schedule.save
                puts "NOT SAVE"
                puts @medication_schedule.errors.inspect
                format.html { redirect_to user_medication_path(user_id: session[:user_id], name: @medication.name), alert: "Failed to create medication schedule." }
            else
                puts "CREATED WENT THROUGH"
                 format.html{ redirect_to user_medication_medication_schedules_path(@user, @medication.name) }
            end
        end
    end

    def new
        @user = current_user
        @medication = @user.medications.find_by(name: params[:medication_name])
    end

    def select
        @medications = Medication.all
        @user = current_user
    end

    def index
        @user = current_user
        @medication = @user.medications.find_by(name: params[:medication_name])
    end


    def destroy
        @user = current_user
        @medication = @user.medications.find_by(name: params[:medication_name])
        @medication_schedule = @medication.medication_schedules.find(params[:id])
    
        if @medication_schedule.destroy
          redirect_to user_medication_medication_schedules_path(@user, @medication.name),
            notice: "Medication schedule was successfully deleted."
        else
          redirect_to user_medication_path(user_id: session[:user_id], name: @medication.name),
            alert: "Failed to delete medication schedule."
        end
    end

    def edit
        @user = current_user
        @medication = @user.medications.find_by(name: params[:medication_name])
        @medication_schedule = @medication.medication_schedules.find(params[:id])
    end

    def update
        @user = current_user
        @medication = @user.medications.find_by(name: params[:medication_name])
        @medication_schedule = @medication.medication_schedules.find(params[:id])

        respond_to do |format|
            if @medication_schedule.update(medication_schedule_params)
            format.html { redirect_to user_medication_path(user_id: session[:user_id], name: @medication.name), notice: "Medication schedule was successfully updated." }
            format.json { render :show, status: :ok, location: @medication_schedule }
            else
            format.html { render :edit }
            format.json { render json: @medication_schedule.errors, status: :unprocessable_entity }
            end
        end
    end

    def get_current_day_schedules
        @user = User.find(session[:user_id])

        @current_day_schedules = []
        current_day_of_week = Time.now.strftime('%A')

        @user.medications.each do |medication|
            medication_schedules = medication.medication_schedules.joins(:day_of_week).where("day_of_weeks.name = ? OR day_of_weeks.name = ?", current_day_of_week, "Everyday")
            medication_schedules.each do |schedule|
              @current_day_schedules << { medication: medication, schedule: schedule }
            end
        end
    end

    def get_day_schedules
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


    def take_med
        puts "TAKE MED ENTERED"
        @user = current_user
        @medication_schedule = MedicationSchedule.find(params[:id])
        #puts "SCHEDULE: " + @medication_schedule.to_s
        @medication_schedule.update(taken: true)
        newAmt = @medication_schedule.medication.amount_left - @medication_schedule.medication.amount_taken
        @medication_schedule.medication.update(amount_left: newAmt)
        puts "UPDATED SCHEDULE"
        date_taken = Date.today
        puts "DATE TAKEN: #{date_taken}"
        
        days_taken = @user.days_taken.find_by(date_taken: date_taken, medication_schedule_id: @medication_schedule.id)
        days_taken.update(taken: true)
        puts "END"
    end

    def untake_med
        @user = current_user
        @medication_schedule = MedicationSchedule.find(params[:id])
        @medication_schedule.update(taken: false)
        newAmt = @medication_schedule.medication.amount_left + @medication_schedule.medication.amount_taken
        @medication_schedule.medication.update(amount_left: newAmt)

        #take out of days_taken
        all_days_taken = DaysTaken.all
        puts "ALL DAYS: " + all_days_taken.length.to_s
        taken_today = DaysTaken.find_by(date_taken: Date.today, medication_schedule: @medication_schedule, taken: true)
        taken_today.update(taken: false)
    end


    private

        def medication_schedule_params
            params.require(:medication_schedule).permit(:day_of_week, :time, :taken).tap do |whitelisted|
            whitelisted[:day_of_week] = DayOfWeek.find(params[:medication_schedule][:day_of_week].to_i)
            end
        end
end
