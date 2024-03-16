namespace :tasks do
        desc "Perform daily task"
        task perform_daily_task: :environment do
          DailyTaskWorker.perform_async
          puts "Daily task enqueued successfully."
        end
end