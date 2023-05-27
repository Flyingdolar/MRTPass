class Station < ApplicationRecord
    validates :linecolor,:number,:x_Pos,:y_Pos,:exit_Num,:name, presence: true
end
