Rails.application.config.middleware.use OmniAuth::Builder do
    # Retrieve the Google credentials from Rails credentials
    # Configure the Google OAuth provider with the client_id and client_secret
    provider :google_oauth2, '363943209879-l76d1n3astafcvhf5482rshjkelu5hk5.apps.googleusercontent.com', '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', {
        scope: 'email, profile', # This grants access to the user's email and profile information.
        prompt: 'select_account', # This allows users to choose the account they want to log in with.
        image_aspect_ratio: 'square', # Ensures the profile picture is a square.
        image_size: 50, # Sets the profile picture size to 50x50 pixels.
      }
  end