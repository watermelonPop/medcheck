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
    auth = request.env['omniauth.auth']
    @user = User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.email = auth['info']['email']
      names = auth['info']['name'].split
      u.first_name = names[0]
      u.last_name = names[1..].join(' ')
    end
    
    if @user.valid?
      url = URI("https://api.onesignal.com/apps/90311568-0504-428b-9c92-0b1dda7bea46/users")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["accept"] = 'application/json'
      request["content-type"] = 'application/json'
      request.body = "{\"identity\":{\"external_id\":\"#{@user.id}\"}}"

      response = http.request(request)
      puts response.read_body
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
