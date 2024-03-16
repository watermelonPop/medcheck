class DailyTaskWorker
        include Sidekiq::Worker
      
        def perform
                # Place the code for the task you want to perform at the scheduled time
                YourModel.perform_task
                schedules = MedicationSchedule.all
                yesterday_schedules = get_yesterday_schedules

                yesterday_schedules.each do |schedule|
                        if(schedule.taken == true)
                                schedule.update(taken: false)
                        else
                                DaysTaken.create(date_taken: (Date.today - 1), schedule: schedule, taken: false)
                        end
                end
        end

        def get_yesterday_schedules
                @user = User.find(session[:user_id])
        
                @yesterday_schedules = []
                yesterday = (Time.now - 1.day).strftime('%A')
        
                @user.medications.each do |medication|
                    medication_schedules = medication.medication_schedules.joins(:day_of_week).where("day_of_weeks.name = ?", yesterday)
                    medication_schedules.each do |schedule|
                      @yesterday_schedules << { medication: medication, schedule: schedule }
                    end
                end
        end

end