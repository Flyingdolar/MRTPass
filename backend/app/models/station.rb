class Station < ApplicationRecord
    validates :x_Pos,:y_Pos,:exit_Num,:name, presence: true
    validates_uniqueness_of :name
    has_many :station_infos, dependent: :destroy
    has_many :station_nos, dependent: :destroy
    has_many :time_tables, dependent: :destroy
end
