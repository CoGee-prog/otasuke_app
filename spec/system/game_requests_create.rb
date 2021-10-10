RSpec.describe '対戦相手検索テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:other_team2) { FactoryBot.create(:other_team2) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:other_team_event1) { FactoryBot.create(:other_team_event1) }
  let!(:other_team_event2) { FactoryBot.create(:other_team_event2) }

  describe '対戦相手検索の対戦申込作成のテスト' do
    it 'チームを検索し、スケジュール詳細画面に遷移して有効な対戦申込を作成' do
      log_in_as(user)
      click_on '対戦相手検索'
      expect(page).to have_current_path search_schedule_teams_path, ignore_query: true
      fill_in 'event_team_search[day_time]', with: '002021-11-21-12:00'
      click_on '検索'
      expect(page).to have_content('イーグルス', count: 1)
      expect(page).not_to have_content('ジャイアンツ', count: 1)
      click_on 'スケジュール詳細'
      expect(page).to have_current_path detail_schedule_team_path(other_team1), ignore_query: true
      expect do
        fill_in 'game_request[contact_address]', with: '000-0000-0000'
        fill_in 'game_request[comment]', with: 'よろしくお願いします！'
        click_on '対戦を申し込む'
      end.to change(GameRequest, :count).by(1)
      expect(page).to have_selector('.alert-success', text: '対戦を申し込みました')
      expect(page).to have_current_path detail_schedule_team_path(other_team1), ignore_query: true
    end

    it '無効な対戦申込' do
      log_in_as(user)
      visit detail_schedule_team_path(other_team1)
      expect(page).to have_current_path detail_schedule_team_path(other_team1), ignore_query: true
      expect do
        fill_in 'game_request[comment]', with: 'よろしくお願いします！'
        click_on '対戦を申し込む'
      end.not_to change(GameRequest, :count)
      expect(page).to have_selector('.form-alert-danger', text: '連絡先、LINEQRコード等はどちらか1つは必ず入力してください')
    end
  end
end
