class Line < ApplicationRecord
    validates_uniqueness_of :linecolor
    validates :linecolor, :name, :colorcode, presence: true
end
