require 'date'
class Event < ApplicationRecord
  belongs_to :team
  has_many :event_entries, dependent: :destroy
  has_one :event_option, dependent: :destroy
  validates :day_time, presence: true
  validates :ground, length: { maximum: 50 }
  validates :opponent_team_name, length: { maximum: 50 }
  validates :tournament_name, length: { maximum: 50 }
  validates :other, length: { maximum: 50 }

  after_create :create_options
  after_create :create_event_entries

  private

  # イベントの出欠カウントを作成する
  def create_options
    create_event_option
  end

  # イベントの出欠を作成する
  def create_event_entries
    team.users.each do |user|
      User.find(user.id).event_entries.create(event_id: id)
    end
  end
end
