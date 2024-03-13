class MedicationSchedulesController < ApplicationController

    def create
        @user = current_user
        @medication = @user.medications.find_by(name: params[:medication_name])
        @medication_schedule = @medication.medication_schedules.build(medication_schedule_params)

        respond_to do |format|
            if !@medication_schedule.save
                puts "NOT SAVE"
                puts @medication_schedule.errors.inspect
                format.html { redirect_to user_medication_path(user_id: session[:user_id], name: @medication.name), alert: "Failed to create medication schedule." }
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
        puts "PARAM: " + params[:medication_name]
        @medication = @user.medications.find_by(name: params[:medication_name])
        puts "NAME: " + @medication.name
    end


    def destroy
        @user = current_user
        @medication = @user.medications.find_by(name: params[:medication_name])
        @medication_schedule = @medication.medication_schedules.find(params[:id])
    
        if @medication_schedule.destroy
          redirect_to user_medication_path(user_id: session[:user_id], name: @medication.name),
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
        puts "PARAM: #{params[:medication_name]}"
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
        puts "BEGIN INDEX"
        @user = User.find(session[:user_id])
        @medication
        
        @current_day_schedules = []
        current_day_of_week = Time.now.strftime('%A')
        puts "TODAY: " + current_day_of_week

        @user.medications.each do |medication|
            puts "MEDICATION: " + medication.name
            puts "ALL MEDS: " + medication.medication_schedules.length.to_s
            medication_schedules = medication.medication_schedules.joins(:day_of_week).where("day_of_weeks.name = ?", current_day_of_week)
            puts "SCHEDULES: " + medication_schedules.length.to_s
            medication_schedules.each do |schedule|
                puts "TIME: " + schedule.time.strftime("%l:%M %p")
              @current_day_schedules << { medication: medication, schedule: schedule }
            end
        end
    end

    def get_day_schedules
        puts "BEGIN INDEX"
        @user = User.find(session[:user_id])
        @medication = @user.medications.find_by(name: params[:medication_name])
        
        @current_day = params[:day_of_week]
        @current_day_schedules = []

        medication_schedules = @medication.medication_schedules.joins(:day_of_week).where("day_of_weeks.name = ?", @current_day)
        medication_schedules = medication_schedules.sort_by { |schedule| schedule.time.strftime("%H:%M") }
        medication_schedules.each do |schedule|
            puts "TIME: " + schedule.time.strftime("%l:%M %p")
            @current_day_schedules << { medication: @medication, schedule: schedule }
        end
    end

    private

        def medication_schedule_params
            params.require(:medication_schedule).permit(:day_of_week, :time).tap do |whitelisted|
            whitelisted[:day_of_week] = DayOfWeek.find(params[:medication_schedule][:day_of_week].to_i)
            end
        end
end
