RSpec.describe 'スケジュール出欠編集テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:event_entry) { EventEntry.find_by(user_id: user, event_id: event) }

  xdescribe 'ユーザーのスケジュール出欠編集' do
    it '有効なスケジュール出欠編集' do
      log_in_as(user)
      click_on 'スケジュール管理'
      expect(page).to have_current_path event_path(team), ignore_query: true
      expect(page).to have_selector('#event', text: '08/03(火) 13:00 札幌ドーム VSイーグルス パ・リーグトーナメント 三塁側 編集 削除')
      click_on ' - '
      expect(page).to have_current_path edit_event_entry_path(event_entry), ignore_query: true
      choose '◯'
      click_on '更新する'
      expect(page).to have_current_path event_path(team), ignore_query: true
      expect(page).to have_selector('.alert-success', text: '出欠を更新しました')
      expect(page).to have_selector('.entry', text: ' ◯ ')
    end
  end
end
