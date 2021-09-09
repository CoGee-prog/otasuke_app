class TeamMember < ApplicationRecord
  belongs_to :team
  belongs_to :user
  validates :team_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  after_create :create_team_event_entries
  after_destroy_commit :destroy_team_event_entries

  # イベント出欠を作成する
  def create_team_event_entries
    Team.find(team_id).events.each do |event|
      User.find(user_id).event_entries.create(event_id: event.id)
    end
  end

  # イベント出欠を削除する
  def destroy_team_event_entries
    Team.find(team_id).events.each do |event|
      User.find(user_id).event_entries.find_by(event_id: event.id, user_id: user_id).destroy
    end
  end
end
