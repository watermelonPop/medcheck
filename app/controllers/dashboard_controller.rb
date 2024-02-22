class DashboardController < ApplicationController
    def index
        @user = User.find(session[:user_id])
        @medications = Medication.all
    end
end
