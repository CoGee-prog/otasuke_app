RSpec.describe 'User/MemberRequests', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:not_admin_user) { FactoryBot.create(:not_admin_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team4) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: other_team1, user: other_user) }
  let!(:member_request1) { FactoryBot.create(:member_request1, team: other_team1, user: user) }

  describe 'ログインしてないユーザーのメンバーリクエストのテスト' do
    it 'メンバーリクエスト作成からリダイレクトされる' do
      post user_member_requests_path(team_id: team.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'メンバーリクエスト削除からリダイレクトされる' do
      delete user_member_request_path(team.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe 'メンバーリクエストがない場合' do
    it 'メンバーリクエスト削除からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect do
        delete user_member_request_path(team)
      end.not_to change(MemberRequest, :count)
      expect(flash[:danger]).to eq 'チーム所属申請がありません'
      expect(response).to redirect_to teams_path
    end
  end

  describe '既にチームに所属している場合' do
    it '所属しているチームにリクエストが送れない' do
      post login_path params: { session: { email: user.email, password: user.password } }
      expect do
        post user_member_requests_path(team_id: team.id)
      end.not_to change(MemberRequest, :count)
      expect(flash[:danger]).to eq '既にチームに所属しています'
    end
  end
end
