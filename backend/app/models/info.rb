class Info < ApplicationRecord
    has_many :station_infos
    has_many :comments
end
