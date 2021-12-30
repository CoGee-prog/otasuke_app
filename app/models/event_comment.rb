class EventComment < ApplicationRecord
  belongs_to :user
  belongs_to :team
  validates :comment, presence: true, length: { maximum: 50 }
end
