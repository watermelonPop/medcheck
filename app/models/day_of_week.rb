class DayOfWeek < ApplicationRecord
    has_many :medication_schedules
    has_many :medications, through: :medication_schedules
end
