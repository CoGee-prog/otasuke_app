RSpec.describe '対戦相手検索テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:other_team2) { FactoryBot.create(:other_team2) }
  let!(:other_team3) { FactoryBot.create(:other_team3) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:other_team_event1) { FactoryBot.create(:other_team_event1) }
  let!(:other_team_event2) { FactoryBot.create(:other_team_event2) }
  let!(:teams) { create_list(:teams, 30) }

  describe '対戦相手検索のテスト' do
    it '日時からチームを検索する' do
      log_in_as(user)
      click_on '対戦相手検索'
      expect(page).to have_current_path search_schedule_teams_path, ignore_query: true
      expect(page).to have_css('.pagination')
      # 検索日時が完全に被っているスケジュールの検索テスト
      fill_in 'event_team_search[day_time]', with: '002021-11-21-12:00'
      click_on '検索'
      expect(page).to have_content('イーグルス', count: 1)
      expect(page).not_to have_content('ジャイアンツ', count: 1)
      expect(page).not_to have_content('ドラゴンズ', count: 1)
      expect(page).not_to have_css('.pagination')
      # 検索日時から前後2時間以内のスケジュール検索テスト
      fill_in 'event_team_search[day_time]', with: '002021-11-14-11:00'
      click_on '検索'
      expect(page).to have_content('ジャイアンツ', count: 1)
      expect(page).not_to have_content('イーグルス', count: 1)
      expect(page).not_to have_content('ドラゴンズ', count: 1)
      expect(page).not_to have_css('.pagination')
      # 検索日時の曜日を活動曜日としているチームの検索テスト
      fill_in 'event_team_search[day_time]', with: '002021-11-12-12:00'
      click_on '検索'
      expect(page).to have_content('ドラゴンズ', count: 1)
      expect(page).not_to have_content('ジャイアンツ', count: 1)
      expect(page).not_to have_content('イーグルス', count: 1)
      expect(page).not_to have_css('.pagination')
    end

    it '活動エリアからチームを検索する' do
      log_in_as(user)
      click_on '対戦相手検索'
      expect(page).to have_current_path search_schedule_teams_path, ignore_query: true
      expect(page).to have_css('.pagination')
      select '青森県', from: 'event_team_search[prefecture_id]'
      click_on '検索'
      expect(page).to have_content('イーグルス', count: 1)
      expect(page).not_to have_content('ジャイアンツ', count: 1)
      expect(page).not_to have_content('ドラゴンズ', count: 1)
      expect(page).not_to have_css('.pagination')
    end

    it 'チームレベルからチームを検索する' do
      log_in_as(user)
      click_on '対戦相手検索'
      expect(page).to have_current_path search_schedule_teams_path, ignore_query: true
      expect(page).to have_css('.pagination')
      select '全国大会上位レベル', from: 'event_team_search[level]'
      click_on '検索'
      expect(page).to have_content('イーグルス', count: 1)
      expect(page).not_to have_content('ジャイアンツ', count: 1)
      expect(page).not_to have_content('ドラゴンズ', count: 1)
      expect(page).not_to have_css('.pagination')
    end
  end
end
