require 'rails_helper'

RSpec.describe 'GameRequests', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:not_admin_user) { FactoryBot.create(:not_admin_user) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:other_team2) { FactoryBot.create(:other_team4) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: team, user: not_admin_user) }
  let!(:team_member3) { FactoryBot.create(:team_member3, team: other_team1, user: other_user) }
  let!(:team_member4) { FactoryBot.create(:team_member4, team: other_team2, user: not_admin_user) }
  let!(:game_request) { FactoryBot.create(:game_request, requested_team_id: other_team2.id) }

  describe 'ログインしてないユーザーの対戦申込アクションのテスト' do
    it '対戦申込登録からリダイレクトされる' do
      post game_requests_path, params: { game_request: { requested_team_id: game_request.requested_team_id, \
                                                         contact_address: game_request.contact_address, \
                                                         comment: game_request.comment } }
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it '試合リクエスト一覧からリダイレクトされる' do
      get game_request_path(team)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe 'チーム管理者ユーザー以外からのスケジュール作成、登録、編集、更新、削除が失敗する' do
    it '対戦申込登録からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      expect do
        post game_requests_path, params: { game_request: { requested_team_id: game_request.requested_team_id, \
                                                           contact_address: game_request.contact_address, comment: game_request.comment } }
      end.not_to change(GameRequest, :count)
      expect(flash[:success]).not_to eq '対戦を申し込みました'
      expect(response).to redirect_to root_path
    end

    it 'スケジュール削除からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      expect do
        delete game_request_path(game_request)
      end.not_to change(GameRequest, :count)
      expect(response).to redirect_to root_path
    end
  end

  describe '別のチームの管理者ユーザーのテスト' do
    it '別のチームの対戦申込削除からホーム画面にリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect do
        delete game_request_path(game_request)
      end.not_to change(GameRequest, :count)
      redirect_to root_path
    end

    it '別のチームの対戦申込一覧から現在のチームの対戦申込一覧にリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      get game_request_path(team)
      expect(response).to redirect_to game_request_path(other_user.current_team_id)
    end
  end
end
