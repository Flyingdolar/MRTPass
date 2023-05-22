class Member < ApplicationRecord
    has_many :comments, dependent: :destroy
    has_many :announcements, dependent: :destroy
    has_many :losts, dependent: :destroy
end
