class StationInfo < ApplicationRecord
    validates :linecolor,:number, presence: true
    belongs_to :info
end
