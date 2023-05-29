class Info < ApplicationRecord
    validates :name, :photo, :address, :type_, :Des, presence: true
    has_many :station_infos
    has_many :comments
    mount_uploader :photo , InfoUploader
end
