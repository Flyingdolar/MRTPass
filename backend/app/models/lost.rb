class Lost < ApplicationRecord
    belongs_to :member
    mount_uploader :photo , LostUploader
end
