RSpec.describe 'スケジュール出欠編集テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:other_event) { FactoryBot.create(:other_event) }
  let!(:event_entry) { EventEntry.find_by(user_id: user, event_id: event) }
  let!(:other_event_entry) { EventEntry.find_by(user_id: user, event_id: other_event) }
  let!(:event_option_entry) { EventOptionEntry.find_by(event_entry_id: event_entry) }
  let!(:other_event_option_entry) { EventOptionEntry.find_by(event_entry_id: other_event_entry) }

  describe 'ユーザーのスケジュール出欠編集' do
    it '有効なスケジュール出欠編集' do
      log_in_as(user)
      click_on 'スケジュール管理'
      expect(page).to have_current_path event_path(team), ignore_query: true
      expect(page).to have_selector('#event', text: '08/03(火) 13:00 札幌ドーム VSイーグルス パ・リーグトーナメント 三塁側 編集 削除')
      expect(page).to have_selector('#event', text: '09/10(金) 13:00 神宮球場 VSスワローズ 交流戦 三塁側 編集 削除')
      click_link('-', match: :first)
      expect(page).to have_current_path edit_event_entry_path(user), ignore_query: true
      within "#0" do
        choose '◯'
      end
      within "#1" do
        choose '△'
      end
      click_on '更新する'
      expect(page).to have_current_path event_path(team), ignore_query: true
      expect(page).to have_selector('.alert__success', text: '出欠を更新しました')
      expect(page).to have_selector('.entry', text: ' ◯ ')
      expect(page).to have_selector('.entry', text: ' △ ')
    end
  end
end
