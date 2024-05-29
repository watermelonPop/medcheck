json.extract! medication, :id, :name, :dose_amount, :dose_unit, :amount_taken, :amount_left, :last_picked_up, :icon, :color, :created_at, :updated_at
json.url medication_url(medication, format: :json)
