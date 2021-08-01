require 'rails_helper'
RSpec.describe 'Team/MemberRequests', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:not_admin_user) { FactoryBot.create(:not_admin_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team) { FactoryBot.create(:other_team) }
  let!(:member_request1) { FactoryBot.create(:member_request1, team: other_team, user: not_admin_user) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: not_admin_user) }

  describe 'ログインしてないユーザーのメンバーリクエストのテスト' do
    it 'メンバーリクエスト一覧からリダイレクトされる' do
      get team_member_request_path(member_request1.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'メンバーリクエスト拒否からリダイレクトされる' do
      delete team_member_request_path(member_request1.id)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe 'チーム管理者ではないユーザーのメンバーリクエストのテスト' do
    it 'メンバーリクエスト一覧からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      get team_member_request_path(member_request1.id)
      expect(response).to redirect_to root_path
    end

    it 'メンバーリクエスト拒否からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      expect do
        delete team_member_request_path(id: member_request1.id)
      end.not_to change(MemberRequest, :count)
      expect(response).to redirect_to root_path
    end
  end

  describe 'メンバーリクエストがない場合' do
    it 'メンバーリクエスト削除からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      delete team_member_request_path(3)
      expect(flash[:danger]).to eq '既に削除されたか存在しないメンバーリクエストです'
      expect(response).to redirect_to team_member_request_path(team.id)
    end
  end

  describe '他チームのメンバーリクエストのテスト' do
    it 'メンバーリクエスト削除からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      expect do
        delete team_member_request_path(member_request1.id)
      end.not_to change(MemberRequest, :count)
      expect(response).to redirect_to root_path
    end
  end
end
