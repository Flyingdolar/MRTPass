class Lost < ApplicationRecord
    validates :item,:time,:location,:lost_Attr, presence: true
    belongs_to :member
    mount_uploader :photo , LostUploader
end
