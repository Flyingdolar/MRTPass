class Info < ApplicationRecord
    has_many :station_infos
    has_many :comments
    mount_uploader :photo , InfoUploader
end
