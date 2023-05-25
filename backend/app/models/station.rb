class Station < ApplicationRecord
    validates :linecolor,:number,:x_Pos,:y_Pos,:isCross,:exit_Num,:name, presence: true
end
