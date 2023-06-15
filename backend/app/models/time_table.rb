class TimeTable < ApplicationRecord
    validates :time,:line,:end,:No, presence: true
    validate  :check_time
    belongs_to :station

    def check_time
        if !time.blank? && !(time>="00:00" && time <"24:00")
            errors.add(:time,"time format error")
            return
        end
    end
end
