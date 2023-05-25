class Line < ApplicationRecord
    validates :linecolor, :name, :colorcode, presence: true
end
