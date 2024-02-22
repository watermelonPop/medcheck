class User < ApplicationRecord
    validates :email, presence: true
    attribute :profile_picture_url, :string
    has_many :medications
end
