RSpec.describe 'チームのメンバーリクエスト承認テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:member_request1) { FactoryBot.create(:member_request1, team: team, user: other_user) }

  describe 'メンバーリクエストを許可する' do
    it '所属申請を許可し、メンバー一覧に表示され、メンバー削除で表示されなくなる' do
      log_in_as(user)
      click_on '所属リクエスト'
      expect(current_path).to eq team_member_request_path(team.id)
      expect do
        click_on '所属承認をする'
      end.to change(MemberRequest, :count).by(-1).and change(TeamMember, :count).by(1)
      expect(current_path).to eq team_member_request_path(team.id)
      expect(page).to have_selector('.alert-success', text: 'チーム所属申請を承認しました')
      click_on 'メンバー一覧'
      expect(current_path).to eq team_team_member_path(team.id)
      expect(page).to have_content('ジロー', count: 1)
      expect do
        click_on '削除'
      end.to change(TeamMember, :count).by(-1)
      expect(current_path).to eq team_team_member_path(team.id)
      expect(page).to have_selector('.alert-success', text: 'メンバーを削除しました')
      expect(page).to have_content('ジロー', count: 0)
    end
  end
end
