require 'rails_helper'

RSpec.describe 'スケジュール出欠編集テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:event_entry) { EventEntry.find_by(user_id: user, event_id: event) }

  it '有効なスケジュール出欠編集' do
    log_in_as(user)
    click_on 'スケジュール管理'
    expect(current_path).to eq event_path(team)
    expect(page).to have_selector('#event', text: '08/03 13:00 札幌ドーム VSイーグルス パ・リーグトーナメント 三塁側 編集 削除')
    click_on ' - '
    expect(current_path).to eq edit_event_entry_path(event_entry)
    choose '◯'
    click_on '更新する'
    expect(current_path).to eq event_path(team)
    expect(page).to have_selector('.alert-success', text: '出欠を更新しました')
    expect(page).to have_selector('.entry', text: ' ◯ ')
  end
end
