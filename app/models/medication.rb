class Medication < ApplicationRecord
        validates :name, presence: true
        validates :dose_amount, presence: true
        validates :dose_unit, presence: true
        validates :amount_left, presence: true
        validates :amount_taken, presence: true
        validates :icon, presence: true
        validates :color, presence: true
        
        has_many :medication_schedules, dependent: :destroy
        belongs_to :user
end
