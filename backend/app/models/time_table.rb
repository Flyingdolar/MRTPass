class TimeTable < ApplicationRecord
    validates :time,:line,:end,:linecolor,:number, presence: true
end
