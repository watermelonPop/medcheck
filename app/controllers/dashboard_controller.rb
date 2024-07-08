class DashboardController < ApplicationController
        def index
                @user = current_user
                @medications = @user.medications
                @current_day_schedules = []
                current_day_of_week = Time.now.strftime('%A')
                @medications.each do |medication|
                        schedules = medication.medication_schedules
                        schedules.each do |schedule|
                                if schedule.day_of_week == current_day_of_week || schedule.day_of_week == "Everyday" 
                                        @current_day_schedules << schedule
                                end
                        end
                end
                @current_day_schedules.sort_by! { |schedule| schedule.time.strftime("%H:%M") }
        end

        def set_taken
                @user = current_user
                @medication = @user.medications.find_by(id: params[:medication_id])
                @medication_schedule = @medication.medication_schedules.find_by(id: params[:id])
                @medication_schedule.update(taken: !@medication_schedule.taken)
                @current_day = DayTaken.find_by(date: Date.today, medication_schedule_id: @medication_schedule.id)
                if @current_day
                        @current_day.update(taken: @medication_schedule.taken)
                else
                        DayTaken.create(date: Date.today, taken: @medication_schedule.taken, user_id: @user.id, medication_schedule_id: @medication_schedule.id)
                end
                redirect_to user_dashboard_index_path(user_id: @current_user.id)
        end
end