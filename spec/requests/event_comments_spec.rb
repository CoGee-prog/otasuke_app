require 'rails_helper'

RSpec.describe "EventComments", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:not_admin_user) { FactoryBot.create(:not_admin_user) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: team, user: not_admin_user) }
  let!(:team_member3) { FactoryBot.create(:team_member3, team: other_team1, user: other_user) }
  let!(:event_comment) { FactoryBot.create(:event_comment) }
  let!(:not_admin_user_event_comment) { FactoryBot.create(:not_admin_user_event_comment) }

  describe 'ログインしてないユーザーのイベントコメントアクションのテスト' do
    it 'イベントコメント登録からリダイレクトされる' do
      post event_comments_path, params: { event_comment: { comment: event_comment.comment, team_id: team.id } }
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'イベントコメント削除からリダイレクトされる' do
      expect do
        delete event_comment_path(event_comment)
      end.not_to change(EventComment, :count)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe 'チーム管理者ユーザー以外は他のユーザーのイベントコメント削除が失敗する' do
    it 'イベントコメント削除からリダイレクトされる' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      expect do
        delete event_comment_path(event_comment)
      end.not_to change(EventComment, :count)
      expect(response).to redirect_to root_path
    end
  end

  describe 'チーム管理者ユーザーは他のユーザーのイベントコメント削除が成功する' do
    it 'イベントコメント削除が成功する' do
      post login_path params: { session: { email: user.email, password: user.password } }
      expect do
        delete event_comment_path(not_admin_user_event_comment)
      end.to change(EventComment, :count).by(-1)
      expect(response).to redirect_to event_path(team)
    end
  end

  describe 'チームに所属していないユーザーのテスト' do
    it '所属していないチームへのイベントコメント登録に失敗し、ホーム画面にリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect do
        post event_comments_path, params: { event_comment: { comment: event_comment.comment, team_id: team.id } }
      end.not_to change(EventComment, :count)
      expect(response).to redirect_to root_path
    end
  end
end
