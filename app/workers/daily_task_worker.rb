class DailyTaskWorker
        include Sidekiq::Worker
      
        def perform
                # Place the code for the task you want to perform at the scheduled time
                puts "BEGINNING OF DAILY TASK !!!!!!!!!"
                YourModel.perform_task
                schedules = MedicationSchedule.all
                today_schedules = get_today_schedules
                puts "TODAYS SCHEDULES: "
                today_schedules.each do |schedule|
                        puts "SCHEDULE: " + schedule.to_s
                        if(schedule.taken == true)
                                puts "WAS TAKEN"
                                schedule.update(taken: false)
                        end
                        DaysTaken.create(date_taken: Date.today, schedule: schedule, taken: false)
                        puts "NEW DAYS TAKEN CREATED"
                end
                puts "END DAILY TASK WORKER"
        end

        def get_today_schedules
                @user = User.find(session[:user_id])
        
                @today_schedules = []
                today = (Time.now).strftime('%A')
        
                @user.medications.each do |medication|
                    medication_schedules = medication.medication_schedules.joins(:day_of_week).where("day_of_weeks.name = ? OR day_of_weeks.name = ?", today, "Everyday")
                    medication_schedules.each do |schedule|
                      @today_schedules << { medication: medication, schedule: schedule }
                    end
                end
                return @today_schedules
        end

end