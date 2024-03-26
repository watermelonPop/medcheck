namespace :onesignal do
        desc "Send notification using OneSignal"
        task send_notification: :environment do
          # Load the Rails environment
          require 'onesignal'
      
          # Configure OneSignal if necessary
          # Ensure that your OneSignal gem initializer has already set the app_id
      
          # Create a new OneSignal::Notification object with the configured app_id
          notification = OneSignal::Notification.new({ app_id: '90311568-0504-428b-9c92-0b1dda7bea46', included_segments: ["Total Subscriptions"], is_ios: true, is_android: true })
      
          # Customize your notification as needed
          notification.contents = { en: "Hello, World!" }
      
          # Send the notification
          api_instance = OneSignal::DefaultApi.new
          begin
            result = api_instance.create_notification(notification)
            puts "Notification sent successfully: #{result}"
          rescue OneSignal::ApiError => e
            puts "Error when calling DefaultApi->create_notification: #{e}"
          end
        end
end