RSpec.describe 'チーム登録テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  describe '新規チームの登録' do
    it '無効なチーム登録' do
      log_in_as(user)
      click_on 'チーム作成'
      expect(page).to have_current_path new_team_path, ignore_query: true
      expect do
        fill_in 'team[name]', with: ''
        click_on '登録する'
      end.not_to change(Team, :count)
      expect(page).to have_selector('.form-alert-danger', text: 'チーム名を入力してください')
      expect(page).to have_selector('.form-alert-danger', text: 'チームレベルを入力してください')
      expect(page).to have_selector('.form-alert-danger', text: '活動エリアを入力してください')
      expect(page).to have_selector('.form-alert-danger', text: '活動曜日を1つ以上選択してください')
      expect(page).to have_current_path teams_path, ignore_query: true
    end

    it '有効なチーム登録' do
      log_in_as(user)
      click_on 'チーム作成'
      expect(page).to have_current_path new_team_path, ignore_query: true
      expect do
        fill_in 'team[name]', with: 'ジャイアンツ'
        select '全国大会上位レベル', from: 'team[level]'
        select '東京', from: 'team[prefecture_id]'
        check 'team[activity_saturday]'
        check 'team[activity_sunday]'
        fill_in 'team[activity_frequency]', with: '週2回'
        fill_in 'team[homepage_url]', with: 'https//giants.com'
        fill_in 'team[other]', with: '精一杯頑張ります'
        click_on '登録する'
      end.to change(Team, :count).by(1)
      expect(page).to have_selector('.alert-success', text: 'チームを作成しました')
      expect(page).to have_current_path root_path, ignore_query: true
      expect(page).to have_selector('.menu', text: 'ジャイアンツ')
    end
  end
end
