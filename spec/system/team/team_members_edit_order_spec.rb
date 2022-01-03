RSpec.describe 'チームメンバーの表示順変更テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: team, user: other_user) }
  let!(:event) { FactoryBot.create(:event) }

  describe 'チームメンバーの表示順を変更する' do
    it 'チーム管理者はスケジュール管理からチームメンバーの表示順を変更できる' do
      log_in_as(user)
      click_on 'スケジュール管理'
      expect(page).to have_current_path event_path(team.id), ignore_query: true
      expect(page.text).to match %r{#{user.name}.*#{other_user.name}}
      expect(page.text).not_to match %r{#{other_user.name}.*#{user.name}}
      click_on 'メンバーの表示順変更'
      expect(page).to have_current_path edit_order_team_team_member_path(team), ignore_query: true
      fill_in "[team_members][#{team_member1.id}][event_order]", with: '2'
      fill_in "[team_members][#{team_member2.id}][event_order]", with: '1'
      click_on '変更する'
      expect(page).to have_current_path event_path(team.id), ignore_query: true
      expect(page).to have_selector('.alert__success', text: 'メンバーの表示順を変更しました')
      expect(page.text).not_to match %r{#{user.name}.*#{other_user.name}}
      expect(page.text).to match %r{#{other_user.name}.*#{user.name}}
    end
  end
end
