class Ticket < ApplicationRecord
    validates :price,:upper_bound,:lower_bound, presence: true
end
