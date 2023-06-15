class Comment < ApplicationRecord
    validates :comment, :score, presence: true
    belongs_to :member
    belongs_to :info
    mount_uploader :photo , CommentUploader
end
