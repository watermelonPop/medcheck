class DailyTaskWorker
        include Sidekiq::Worker
      
        def perform
                # Place the code for the task you want to perform at the scheduled time
                puts "BEGINNING OF DAILY TASK !!!!!!!!!"
                @users = User.all
                @users.each do |user|
                        today_schedules = get_today_schedules(user)
                        puts "TODAYS SCHEDULES: "
                        today_schedules.each do |schedule|
                                puts "SCHEDULE: " + schedule.to_s
                                if(schedule[:schedule].taken == true)
                                        puts "WAS TAKEN"
                                        schedule[:schedule].update(taken: false)
                                end
                                user.days_taken.create(date_taken: Date.today, schedule: schedule[:schedule], taken: false)
                                puts "NEW DAYS TAKEN CREATED"
                        end
                end
                puts "END DAILY TASK WORKER"
        end

        def get_today_schedules(user)
                @today_schedules = []
                today = (Time.now).strftime('%A')
        
                user.medications.each do |medication|
                    medication_schedules = medication.medication_schedules.joins(:day_of_week).where("day_of_weeks.name = ? OR day_of_weeks.name = ?", today, "Everyday")
                    medication_schedules.each do |schedule|
                      @today_schedules << { medication: medication, schedule: schedule }
                    end
                end
                return @today_schedules
        end

end