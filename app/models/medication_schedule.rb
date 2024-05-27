class MedicationSchedule < ApplicationRecord
        belongs_to :medication
        validates :time, presence: true
end
