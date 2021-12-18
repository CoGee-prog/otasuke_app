RSpec.describe 'チームメンバーの表示名変更テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: team, user: other_user) }
  let!(:event) { FactoryBot.create(:event) }

  describe 'チームメンバーの表示名を変更する' do
    it 'チーム管理者はスケジュール管理から全てのチームメンバーの表示名を変更できる' do
      log_in_as(user)
      click_on 'スケジュール管理'
      expect(page).to have_current_path event_path(team.id), ignore_query: true
      expect(page).to have_content('ジロー', count: 1)
      expect(page).to have_content('じろー', count: 0)
      click_on 'ジロー'
      expect(page).to have_current_path edit_team_team_member_path(team_member2.id), ignore_query: true
      fill_in 'team_member[display_name]', with: 'じろー'
      click_on '更新する'
      expect(page).to have_current_path event_path(team.id), ignore_query: true
      expect(page).to have_selector('.alert__success', text: '表示名を更新しました')
      expect(page).to have_content('ジロー', count: 0)
      expect(page).to have_content('じろー', count: 1)
    end
  end
end
