class MedicationSchedule < ApplicationRecord
  belongs_to :medication
  belongs_to :day_of_week

  validates :time, presence: true
end
