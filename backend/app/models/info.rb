class Info < ApplicationRecord
    validates :name, :photo, :address, :type_, :Des, presence: true
    has_many :station_infos , dependent: :destroy
    has_many :comments , dependent: :destroy
    mount_uploader :photo , InfoUploader
end
