RSpec.describe '所属チーム検索テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:teams) { create_list(:teams, 30) }

  describe '所属チームを検索する' do
    it 'チームを検索する' do
      log_in_as(user)
      click_on '所属チーム検索'
      expect(current_path).to eq teams_path
      expect(page).to have_css('.pagination')
      fill_in 'search', with: 'イーグルス'
      click_on '検索'
      expect(page).to have_content('イーグルス', count: 1)
      expect(page).not_to have_css('.pagination')
    end
  end
end
