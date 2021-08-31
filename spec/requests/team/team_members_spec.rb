require 'rails_helper'

RSpec.describe 'Team::TeamMembers', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:not_admin_user) { FactoryBot.create(:not_admin_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:member_request1) { FactoryBot.create(:member_request1, team: team, user: other_user) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: not_admin_user) }

  describe 'ログインしてないユーザーのチーム所属のテスト' do
    it 'メンバー一覧からリダイレクトされる' do
      get team_team_member_path(team)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'メンバーリクエスト承認からリダイレクトされる' do
      post team_team_members_path(id: member_request1.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'メンバー削除からリダイレクトされる' do
      delete team_team_member_path(id: team_member1.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe 'チーム管理者ではないユーザーのチーム所属のテスト' do
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
        delete team_team_member_path(id: team_member1.id)
      end.not_to change(TeamMember, :count)
      expect(response).to redirect_to root_path
    end
  end

  describe 'メンバーリクエストがない場合' do
    it 'チームメンバー作成からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      post team_team_members_path(id: 2)
      expect(flash[:danger]).to eq '既に削除されているか存在しないメンバーリクエストです'
      expect(response).to redirect_to team_member_request_path(team.id)
    end
  end

  describe 'メンバー所属がない場合' do
    it 'チームメンバー削除からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      delete team_team_member_path(id: 2)
      expect(flash[:danger]).to eq '既に削除されているか存在しないメンバーです'
      expect(response).to redirect_to team_team_member_path(team.id)
    end
  end

  describe 'チームメンバーが保存できない場合' do
    it 'user_idがnilの場合は保存できない' do
      team_member1.user_id = nil
      expect(team_member1).not_to be_valid
    end

    it 'team_idがnilの場合は保存できない' do
      team_member1.team_id = nil
      expect(team_member1).not_to be_valid
    end
  end

  describe 'チームメンバーの一意性の検証' do
    it 'user_idとteam_idの組み合わせは一意でないと保存できない' do
      invalid_team_member = FactoryBot.build(:team_member1, team: team, user: not_admin_user)
      expect(invalid_team_member).not_to be_valid
    end
  end
end
