class MedicationSchedulesController < ApplicationController

    def create
        @user = current_user
        @medication = @user.medications.find_by(name: params[:medication_name])
        @medication_schedule = @medication.medication_schedules.build(medication_schedule_params)

        respond_to do |format|
            if @medication_schedule.save
                puts "SAVE"
                format.html { redirect_to user_medication_path(user_id: session[:user_id], name: @medication.name), notice: "Medication schedule was successfully created." }
                format.json { render :show, status: :created, location: @medication_schedule }
            else
                puts "NOT SAVE"
                puts @medication_schedule.errors.inspect
                format.html { redirect_to user_medication_path(user_id: session[:user_id], name: @medication.name), alert: "Failed to create medication schedule." }
            end
        end
    end

    private

        def medication_schedule_params
            params.require(:medication_schedule).permit(:day_of_week, :time).tap do |whitelisted|
            whitelisted[:day_of_week] = DayOfWeek.find(params[:medication_schedule][:day_of_week].to_i)
            end
        end
end
