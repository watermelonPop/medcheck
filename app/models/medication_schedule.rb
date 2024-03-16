class MedicationSchedule < ApplicationRecord
  belongs_to :medication
  belongs_to :day_of_week
  has_many :days_takens

  validates :time, presence: true
end
