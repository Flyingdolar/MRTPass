class TimeTable < ApplicationRecord
    validates :time,:line,:end, presence: true
    belongs_to :station
end
