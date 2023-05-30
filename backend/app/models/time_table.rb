class TimeTable < ApplicationRecord
    validates :time,:line,:end,:linecolor,:number, presence: true
    belongs_to :station
end
