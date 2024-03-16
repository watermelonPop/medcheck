class DashboardController < ApplicationController
    def index
        @user = User.find(session[:user_id])
        @medications = Medication.all
        
        @current_day_schedules = []
        current_day_of_week = Time.now.strftime('%A')

        @user.medications.each do |medication|
            medication_schedules = medication.medication_schedules.joins(:day_of_week).where("day_of_weeks.name = ?", current_day_of_week)

            medication_schedules.each do |schedule|
              @current_day_schedules << { medication: medication, schedule: schedule }
            end
        end

        @current_day_schedules.sort_by! { |schedule| schedule[:schedule].time.strftime("%H:%M") }
    end
end
