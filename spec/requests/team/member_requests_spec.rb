RSpec.describe 'Team/MemberRequests', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:not_admin_user) { FactoryBot.create(:not_admin_user) }
  let!(:unrelated_user) { FactoryBot.create(:unrelated_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:member_request1) { FactoryBot.create(:member_request1, team: team, user: unrelated_user) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: other_team1, user: other_user) }
  let!(:team_member3) { FactoryBot.create(:team_member3, team: team, user: not_admin_user) }

  describe 'ログインしてないユーザーのメンバーリクエストのテスト' do
    it 'メンバーリクエスト一覧からリダイレクトされる' do
      get team_member_request_path(member_request1)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'メンバーリクエスト拒否からリダイレクトされる' do
      delete team_member_request_path(member_request1)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe 'チーム管理者ではないユーザーのメンバーリクエストのテスト' do
    it 'メンバーリクエスト一覧からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      get team_member_request_path(member_request1)
      expect(response).to redirect_to root_path
    end

    it 'メンバーリクエスト拒否からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      expect do
        delete team_member_request_path(member_request1)
      end.not_to change(MemberRequest, :count)
      expect(response).to redirect_to root_path
    end
  end

  describe 'メンバーリクエストがない場合' do
    it 'メンバーリクエスト削除からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      delete team_member_request_path(3)
      expect(flash[:danger]).to eq '既に削除されたか存在しないメンバーリクエストです'
      expect(response).to redirect_to team_member_request_path(team)
    end
  end

  describe '別のチームの管理者のメンバーリクエストのテスト' do
    it 'メンバーリクエスト削除からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect do
        delete team_member_request_path(member_request1)
      end.not_to change(MemberRequest, :count)
      expect(response).to redirect_to root_path
    end

    it '別のチームのメンバーリクエスト一覧から現在のチームのメンバーリクエスト一覧にリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      get team_member_request_path(team)
      expect(response).to redirect_to team_member_request_path(other_user.current_team_id)
    end
  end
end
