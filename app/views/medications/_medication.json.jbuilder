json.extract! medication, :id, :name, :amount_taken, :dose, :amount_left, :last_picked_up, :created_at, :updated_at
json.url medication_url(medication, format: :json)
