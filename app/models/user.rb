class User < ApplicationRecord
        validates :email, presence: true
        has_many :medications, dependent: :destroy
        has_many :day_takens, dependent: :destroy

end
