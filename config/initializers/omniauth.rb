Rails.application.config.middleware.use OmniAuth::Builder do
  google_credentials = Rails.application.credentials.google

  provider :google_oauth2, google_credentials[:client_id], google_credentials[:client_secret], {
    scope: 'email, profile',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 50,
    access_type: 'offline',  # This ensures refresh tokens are received
    redirect_uri: "#{ENV['HOST_URL']}/auth/google_oauth2/callback" # Ensure this matches your callback URL
  }
end

OmniAuth.config.allowed_request_methods = [:post, :get] # Ensure GET is allowed
OmniAuth.config.silence_get_warning = true # Silence the warning for allowing GET requests
