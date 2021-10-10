RSpec.describe 'チーム編集テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  describe 'チームの編集テスト' do
    it '無効なチーム編集' do
      log_in_as(user)
      click_on 'ファイターズ'
      expect(page).to have_current_path team_path(team), ignore_query: true
      click_on '編集する'
      expect(page).to have_current_path edit_team_path(team), ignore_query: true
      fill_in 'team[name]', with: ''
      click_on '更新する'
      expect(page).to have_selector('.form-alert-danger', text: 'チーム名を入力してください')
      expect(page).to have_current_path team_path(team), ignore_query: true
    end

    it '有効なチーム登録' do
      log_in_as(user)
      click_on 'ファイターズ'
      expect(page).to have_current_path team_path(team), ignore_query: true
      click_on '編集する'
      expect(page).to have_current_path edit_team_path(team), ignore_query: true
      fill_in 'team[name]', with: 'ジャイアンツ'
      click_on '更新する'
      expect(page).to have_selector('.alert-success', text: 'チームプロフィールを更新しました')
      expect(page).to have_current_path team_path(team), ignore_query: true
    end
  end
end
