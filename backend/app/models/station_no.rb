class StationNo < ApplicationRecord
    validates :linecolor, :number, presence: true
    belongs_to :station
end
