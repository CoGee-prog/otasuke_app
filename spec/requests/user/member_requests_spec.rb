require 'rails_helper'

RSpec.describe 'User/MemberRequests', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team) { FactoryBot.create(:other_team) }
  let!(:member_request1) { FactoryBot.create(:member_request1, team: team, user: user) }
  let!(:team_member1) { FactoryBot.create(:team_member1, user: user, team: other_team) }

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

  describe 'メンバーリクエストが保存できない場合' do
    it 'user_idがnilの場合は保存できない' do
      member_request1.user_id = nil
      expect(member_request1).not_to be_valid
    end

    it 'team_idがnilの場合は保存できない' do
      member_request1.team_id = nil
      expect(member_request1).not_to be_valid
    end
  end

  describe '既にチームに所属している場合' do
    it '所属しているチームにリクエストが送れない' do
      post login_path params: { session: { email: user.email, password: user.password } }
      expect do
        post user_member_requests_path(team_id: other_team.id)
      end.not_to change(MemberRequest, :count)
      expect(flash[:danger]).to eq '既にチームに所属しています'
    end
  end

  describe 'メンバーリクエストの一意性の検証' do
    it 'user_idとteam_idの組み合わせは一意でないと保存できない' do
      invalid_member_request = FactoryBot.build(:member_request1, team: team, user: user)
      expect(invalid_member_request).not_to be_valid
    end
  end
end
