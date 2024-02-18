class PublicMedicationsController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_action :require_login

  
    def decrement
        @user = User.find_by(email: params[:email])
        @medication = medication = @user.medications.find_by(name: params[:medication_name])
        if medication
            new_amount_left = medication.amount_left - 1
            medication.update(amount_left: new_amount_left)
            render json: { message: 'Medication amount updated successfully' }
        else
            render json: { error: 'Medication not found' }, status: :not_found
        end
    end
end