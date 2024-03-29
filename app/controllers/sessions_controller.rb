class SessionsController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_action :require_login, only: [:omniauth]
  # GET /logout
  def logout
    reset_session
    redirect_to welcome_path, notice: 'You are logged out.'
  end

  # GET /auth/google_oauth2/callback
  def omniauth
    require 'onesignal'
    auth = request.env['omniauth.auth']
    @user = User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.email = auth['info']['email']
      names = auth['info']['name'].split
      u.first_name = names[0]
      u.last_name = names[1..].join(' ')
    end
    
    if @user.valid?
      OneSignal.login(@user.id.to_s)
      set_session
    else
      redirect_to welcome_path, alert: 'Login failed.'
    end
  end

  def set_session
    session[:user_id] = @user.id
    redirect_to user_dashboard_index_path(@user), notice: 'You are logged in.'
  end
end
