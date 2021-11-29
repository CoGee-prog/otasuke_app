RSpec.describe 'Team::TeamMembers', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:not_admin_user) { FactoryBot.create(:not_admin_user) }
  let!(:unrelated_user) { FactoryBot.create(:unrelated_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:other_team2) { FactoryBot.create(:other_team4) }
  let!(:member_request1) { FactoryBot.create(:member_request1, team: team, user: unrelated_user) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: team, user: not_admin_user) }
  let!(:team_member3) { FactoryBot.create(:team_member3, team: other_team1, user: other_user) }
  let!(:team_member4) { FactoryBot.create(:team_member4, team: other_team2, user: user) }

  describe 'ログインしてないユーザーのチームメンバーのテスト' do
    it 'メンバー一覧からリダイレクトされる' do
      get team_team_member_path(team)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'メンバーリクエスト承認からリダイレクトされる' do
      post team_team_members_path(member_request1.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'メンバー削除からリダイレクトされる' do
      delete team_team_member_path(team_member1.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'メンバー表示名編集からリダイレクトされる' do
      get edit_team_team_member_path(team_member1.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'メンバー表示名更新からリダイレクトされる' do
      patch team_team_member_path(team_member1.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe 'チーム管理者ではないユーザーのチームメンバーのテスト' do
    it 'メンバー一覧からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      get team_team_member_path(team)
      expect(response).to redirect_to root_path
    end

    it 'メンバーリクエスト承認からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      expect do
        post team_team_members_path(id: member_request1.id)
      end.to not_change(MemberRequest, :count).and not_change(TeamMember, :count)
      expect(response).to redirect_to root_path
    end

    it 'メンバー削除からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      expect do
        delete team_team_member_path(team_member1)
      end.not_to change(TeamMember, :count)
      expect(response).to redirect_to root_path
    end

    it 'メンバー表示名編集からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      get edit_team_team_member_path(team_member1.id)
      expect(response).to redirect_to event_path(not_admin_user.current_team_id)
    end

    it 'メンバー表示名更新からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      patch team_team_member_path(team_member1.id)
      expect(response).to redirect_to event_path(not_admin_user.current_team_id)
    end
  end

  describe 'メンバーリクエストがない場合' do
    it 'チームメンバー承認からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      post team_team_members_path(2)
      expect(flash[:danger]).to eq '既に削除されているか存在しないメンバーリクエストです'
      expect(response).to redirect_to team_member_request_path(team)
    end
  end

  describe 'メンバー所属がない場合' do
    it 'チームメンバー削除からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      delete team_team_member_path(2)
      expect(flash[:danger]).to eq '既に削除されているか存在しないメンバーです'
      expect(response).to redirect_to team_team_member_path(team)
    end
  end

  describe '別のチームの管理者のチームメンバーのテスト' do
    it 'メンバーリクエスト承認からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect do
        post team_team_members_path(id: member_request1.id)
      end.to not_change(MemberRequest, :count).and not_change(TeamMember, :count)
      expect(response).to redirect_to root_path
    end

    it 'チームメンバー削除からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect do
        delete team_team_member_path(team_member4)
      end.not_to change(TeamMember, :count)
      expect(response).to redirect_to root_path
    end

    it '別のチームのチームメンバー一覧から現在のチームのメンバー一覧にリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      get team_team_member_path(team)
      expect(response).to redirect_to team_team_member_path(other_user.current_team_id)
    end

    it 'メンバー表示名編集から現在のチームのスケジュール管理にリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      get edit_team_team_member_path(team_member1.id)
      expect(response).to redirect_to event_path(other_user.current_team_id)
    end

    it 'メンバー表示名更新から現在のチームのスケジュール管理にリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      patch team_team_member_path(team_member1.id)
      expect(response).to redirect_to event_path(other_user.current_team_id)
    end
  end
end
