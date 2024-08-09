class MedicationSchedule < ApplicationRecord
        belongs_to :medication
        validates :time, presence: true
        has_many :day_takens, dependent: :destroy
end
