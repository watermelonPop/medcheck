class Medication < ApplicationRecord
    validates :name, presence: true
    validates :dose_amount, presence: true
    validates :dose_unit, presence: true
    validates :amount_left, presence: true
    validates :amount_taken, presence: true
    validates :icon, presence: true
    validates :color, presence: true
  
    has_many :medication_schedules, dependent: :destroy
    has_many :days_of_week, through: :medication_schedules
    belongs_to :user

    def next_pickup
        days_until_empty = amount_left / amount_taken
        next_pickup_date = Date.today + days_until_empty
        return next_pickup_date
    end
end