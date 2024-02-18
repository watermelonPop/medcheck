class Medication < ApplicationRecord
    validates :name, presence: true

    has_many :medication_schedules
    has_many :days_of_week, through: :medication_schedules
    belongs_to :user
end
