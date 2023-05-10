class Station < ApplicationRecord
    has_many :station_infos
    has_many :time_tables
end
