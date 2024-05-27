json.extract! medication_schedule, :id, :time, :day_of_week, :taken, :created_at, :updated_at
json.url medication_schedule_url(medication_schedule, format: :json)
