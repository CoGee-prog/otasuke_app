RSpec.describe 'スケジュール編集テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:event) { FactoryBot.create(:event) }

  describe 'チーム管理者によるスケジュール編集' do
    it '無効なスケジュール編集' do
      log_in_as(user)
      click_on 'スケジュール管理'
      expect(page).to have_current_path event_path(team), ignore_query: true
      click_on '編集'
      fill_in 'event[day_time]', with: ''
      fill_in 'event[ground]', with: '札幌ドーム'
      fill_in 'event[opponent_team_name]', with: 'イーグルス'
      fill_in 'event[tournament_name]', with: 'パ・リーグトーナメント'
      fill_in 'event[other]', with: '三塁側'
      click_on '更新する'
      expect(page).to have_selector('.form__alert--danger', text: '日時を入力してください')
      expect(page).to have_current_path event_path(event), ignore_query: true
    end

    it '有効なスケジュール編集' do
      log_in_as(user)
      click_on 'スケジュール管理'
      expect(page).to have_current_path event_path(team), ignore_query: true
      click_on '編集'
      fill_in 'event[day_time]', with: '002021-12-01-10:00'
      fill_in 'event[ground]', with: '東京ドーム'
      fill_in 'event[opponent_team_name]', with: 'ジャイアンツ'
      fill_in 'event[tournament_name]', with: '交流戦'
      fill_in 'event[other]', with: '三塁側'
      click_on '更新する'
      expect(page).to have_selector('.alert__success', text: 'スケジュールを更新しました')
      expect(page).to have_current_path event_path(team), ignore_query: true
      expect(page).to have_selector('#event', text: '12/01(水) 10:00 東京ドーム VSジャイアンツ 交流戦 三塁側 編集 削除')
    end
  end
end
