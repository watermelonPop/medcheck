namespace :every_day do
        desc "Run every Morning"
        task every_day_task: :environment do
                @users = User.all
                @users.each do |user|
                        medications = user.medications
                        medications.each do |medication|
                                med_sched = medication.medication_schedules
                                med_sched.each do |med_sch|
                                        med_sch.update(taken: false)
                                        user.day_takens.create(date: Date.today, taken: false, medication_schedule_id: med_sch.id)
                                end
                        end
                end
        end
end