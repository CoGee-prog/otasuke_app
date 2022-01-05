RSpec.describe 'Users', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }

  describe 'ログインしていないユーザーのアクションテスト' do
    it 'ログインしていない時、ユーザー編集からリダイレクトされる' do
      get edit_user_path(user)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'ログインしていない時、ユーザー更新からリダイレクトされる' do
      patch user_path(user), params: { user: { name: user.name, email: user.email } }
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'ログインしていない時、アカウント削除からリダイレクトされる' do
      delete user_path(user)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe '他のユーザーのプロフィール編集が失敗する' do
    before do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
    end

    it '間違ったユーザーがログインした時、ユーザー編集からリダイレクトされる' do
      get edit_user_path(user)
      expect(response).to redirect_to edit_user_path(other_user)
    end

    it '間違ったユーザーがログインした時、ユーザー更新からリダイレクトされる' do
      patch user_path(user), params: { user: { name: user.name, email: user.email } }
      expect(flash[:success]).not_to eq 'ユーザープロフィールを更新しました'
      expect(response).to redirect_to root_path
    end

    it '間違ったユーザーがログインした時、アカウント削除からリダイレクトされる' do
      delete user_path(user), params: { user: { name: user.name, email: user.email } }
      expect(flash[:success]).not_to eq 'アカウントを削除しました'
      expect(response).to redirect_to root_path
    end
  end

  describe 'ユーザー管理者に関するテスト' do
    before do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
    end

    it 'Web上でユーザー管理者属性を編集できない' do
      expect(other_user.admin?).to be_falsey
      patch user_path(other_user),
            params: { user: { password: 'password', password_confirmation: 'password', admin: true } }
      other_user.reload
      expect(other_user.admin?).to be_falsey
    end

    it 'ユーザー管理者ではないユーザーの場合、他のユーザー削除からリダイレクトされる' do
      expect do
        delete user_path(user)
      end.not_to change(User, :count)
      expect(response).to redirect_to root_path
    end
  end
end
