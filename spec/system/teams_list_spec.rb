RSpec.describe 'チーム切り替えテスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: other_team1, user: user) }

  describe '現在のチームを切り替える' do
    it 'チームを切り替える' do
      log_in_as(user)
      expect(page).to have_selector('.menu', text: 'ファイターズ')
      click_on 'チーム切り替え'
      expect(current_path).to eq list_team_path(user)
      click_on 'イーグルス'
      expect(current_path).to eq event_path(other_team1)
      expect(page).to have_selector('.menu', text: 'イーグルス')
    end
  end
end
