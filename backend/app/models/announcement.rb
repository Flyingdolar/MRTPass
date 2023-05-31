class Announcement < ApplicationRecord
    validates :topic, :context, presence: true
    belongs_to :member
end
