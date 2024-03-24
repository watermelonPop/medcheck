class ServiceWorkersController < ApplicationController
        # Serve the OneSignal service worker file
        def onesignal_sdk_worker
          # Set the content type to JavaScript
          response.headers['Content-Type'] = 'application/javascript'
          # Render the service worker file
          render file: 'public/OneSignalSDKWorker.js', layout: false
        end
end