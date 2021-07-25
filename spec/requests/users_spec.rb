require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }

  describe 'GET /new' do
    it 'returns http success' do
      get '/signup'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'ユーザーeditアクションのテスト' do
    it 'ログインしていない時、ユーザーeditからリダイレクトされる' do
      get edit_user_path(user)
      expect(flash[:danger]).to be_truthy
      expect(response).to redirect_to login_path
    end

    it 'ログインしていない時、ユーザーupdateからリダイレクトされる' do
      patch user_path(user), params: { user: { name: user.name, email: user.email } }
      expect(flash[:danger]).to be_truthy
      expect(response).to redirect_to login_path
    end
  end

  describe '他のユーザーのプロフィール編集が失敗する' do
    it '間違ったユーザーがログインした時、ユーザーeditからリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      get edit_user_path(user)
      expect(response).to redirect_to root_path
    end

    it '間違ったユーザーがログインした時、ユーザーupdateからリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      patch user_path(user), params: { user: { name: user.name, email: user.email } }
      expect(flash[:success]).not_to eq 'ユーザープロフィールを更新しました'
      expect(response).to redirect_to root_path
    end
  end

  describe 'ユーザー管理者属性に関するテスト' do
    it 'Web上でユーザー管理者属性を編集できない' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect(other_user.admin?).to be_falsey
      patch user_path(other_user),
            params: { user: { password: 'password', password_confirmation: 'password', admin: true } }
      other_user.reload
      expect(other_user.admin?).to be_falsey
    end

    it 'ログインしていないユーザーの場合、destroyからリダイレクトされる' do
      expect do
        delete user_path(user)
      end.not_to change(User, :count)
      expect(response).to redirect_to login_path
    end

    it 'ユーザー管理者ではないユーザーの場合、destroyからリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect do
        delete user_path(user)
      end.not_to change(User, :count)
      expect(response).to redirect_to root_path
    end
  end
end
