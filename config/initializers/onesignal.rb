require 'onesignal'

# setup authorization
OneSignal.configure do |config|
  # Configure Bearer authorization: app_key
  config.app_key = 'NmYzZTEzMDgtZjZmYS00ZTI4LWJjOTYtMjFkNWM5ZDU1NTRi'
end

api_instance = OneSignal::DefaultApi.new
notification = OneSignal::Notification.new({app_id: '90311568-0504-428b-9c92-0b1dda7bea46'}) # Notification

begin
  # Create notification
  result = api_instance.create_notification(notification)
  p result
rescue OneSignal::ApiError => e
  puts "Error when calling DefaultApi->create_notification: #{e}"
end