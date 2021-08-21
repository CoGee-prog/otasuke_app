class Event < ApplicationRecord
  belongs_to :team
  has_many :event_entries, dependent: :destroy
  has_one :event_option, dependent: :destroy
  validates :day, presence: true
  validates :time, presence: true
  validates :ground, length: { maximum: 50 }
  validates :opponent_team_name, length: { maximum: 50 }
  validates :tournament_name, length: { maximum: 50 }
  validates :other, length: { maximum: 50 }

  after_create :create_options
  after_create :create_event_entries

  private

  def create_options
    create_event_option
  end

  def create_event_entries
    team.team_members.each do |member|
      User.find(member.user_id).event_entries.create(event_id: id)
    end
  end
end
