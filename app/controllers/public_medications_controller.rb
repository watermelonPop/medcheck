class PublicMedicationsController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_action :require_login

  
    def decrement
        @user = User.find_by(email: params[:email])
        @medication = @user.medications.find_by(name: params[:medication_name])
        if @medication
            new_amount_left = @medication.amount_left - @medication.amount_taken
            @medication.update(amount_left: new_amount_left)
            @current_day_schedules = get_current_day_schedules()
            #puts "HELLO: " + @current_day_schedules.to_s
            @current_day_schedules.each do |schedule|
                puts "SIMONE: " + schedule[:medication].name
                if(schedule[:medication].name == @medication.name && schedule[:schedule].taken == false)
                    schedule[:schedule].update(taken: true)
                    break
                end
            end
            render json: { message: 'Medication amount updated successfully' }
        else
            render json: { error: 'Medication not found' }, status: :not_found
        end
    end

    def increment
        @user = User.find_by(email: params[:email])
        @medication = @user.medications.find_by(name: params[:medication_name])
        if @medication
            new_amount_left = @medication.amount_left + @medication.amount_taken
            @medication.update(amount_left: new_amount_left)
            @current_day_schedules = get_current_day_schedules()
            #puts "HELLO: " + @current_day_schedules.to_s
            selectedSched = @current_day_schedules[0]
            @current_day_schedules.each do |schedule|
                if(schedule[:medication].name == @medication.name && schedule[:schedule].taken == true)
                    selectedSched = schedule
                end
            end
            selectedSched[:schedule].update(taken: false)
            render json: { message: 'Medication amount updated successfully' }
        else
            render json: { error: 'Medication not found' }, status: :not_found
        end
    end

    def get_current_day_schedules
        @user = User.find(session[:user_id])

        @current_day_schedules = []
        current_day_of_week = Time.now.strftime('%A')
        @user.medications.each do |medication|
            medication_schedules = medication.medication_schedules.joins(:day_of_week).where("day_of_weeks.name = ?", current_day_of_week)
            medication_schedules.each do |schedule|
              @current_day_schedules << { medication: medication, schedule: schedule }
            end
        end
        puts "IN METHOD: " + @current_day_schedules.to_s
        @current_day_schedules
    end
end