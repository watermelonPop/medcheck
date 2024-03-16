class DaysTaken < ApplicationRecord
        belongs_to :medication_schedule
        belongs_to :user
end