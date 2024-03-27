namespace :onesignal do
        desc "Send notification using OneSignal"
        task schedule_notifications: :environment do
          # Load the Rails environment
          require 'onesignal'
          
          # Configure OneSignal if necessary
          # Ensure that your OneSignal gem initializer has already set the app_id
          
          # Fetch all users with their external IDs
          users = User.pluck(:id)
          
          api_instance = OneSignal::DefaultApi.new
          
          users.each do |user_id|
            # Create a new OneSignal::Notification object with the configured app_id
            notification = OneSignal::Notification.new({ app_id: '90311568-0504-428b-9c92-0b1dda7bea46', include_external_user_ids: [user_id], is_any_web: true })
            
            # Customize your notification as needed
            notification.contents = { en: "Hello, User #{user_id}! This is a personalized message." }
            
            begin
              result = api_instance.create_notification(notification)
              puts "Notification sent successfully to User #{user_id}: #{result}"
            rescue OneSignal::ApiError => e
              puts "Error when sending notification to User #{user_id}: #{e}"
            end
          end
        end
end