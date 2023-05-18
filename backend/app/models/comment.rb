class Comment < ApplicationRecord
    
    belongs_to :member
    belongs_to :info
    mount_uploader :photo , CommentUploader
end
