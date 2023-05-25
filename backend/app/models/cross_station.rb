class CrossStation < ApplicationRecord
    validates :number_1,:number_2,:linecolor_1,:linecolor_2, presence: true
end
