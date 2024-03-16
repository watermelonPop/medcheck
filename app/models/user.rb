class User < ApplicationRecord
    validates :email, presence: true
    attribute :profile_picture_url, :string
    has_many :medications
    has_many :days_taken
    def user_days_taken
        days_taken.order(date_taken: :desc)
    end
    def taken_on_date(date)
        @taken_on_day = days_taken.where(date_taken: date)
    end
    def unique_user_days
        @unique_days = days_taken.uniq.pluck(:date_taken)
    end
end
