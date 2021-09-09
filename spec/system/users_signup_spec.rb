RSpec.describe 'ユーザー登録テスト', type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  describe 'ユーザー登録のテスト' do
    it '無効なユーザー登録' do
      visit root_path
      click_on '新規登録'
      expect(current_path).to eq signup_path
      expect do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: 'hoge'
        fill_in 'user[password_confirmation]', with: 'fuga'
        click_on '登録する'
      end.not_to change(User, :count)
      expect(page).to have_selector('.form-alert-danger', text: 'ニックネームを入力してください')
      expect(page).to have_selector('.form-alert-danger', text: 'メールアドレスを入力してください')
      expect(page).to have_selector('.form-alert-danger', text: 'パスワードは6文字以上で入力してください')
      expect(page).to have_selector('.form-alert-danger', text: 'パスワード（確認用）とパスワードの入力が一致しません')
      expect(current_path).to eq users_path
    end

    it '有効なユーザー登録' do
      visit root_path
      click_on '新規登録'
      expect(current_path).to eq signup_path
      expect do
        fill_in 'user[name]', with: 'hoge'
        fill_in 'user[email]', with: 'hoge@example.com'
        fill_in 'user[password]', with: 'hogehoge'
        fill_in 'user[password_confirmation]', with: 'hogehoge'
        click_on '登録する'
        expect(ActionMailer::Base.deliveries.size).to eq 1
        user = User.last
        mail = ActionMailer::Base.deliveries.last
        token = mail.text_part.body.encoded[%r{(?<=account_activations/)[^/]+}]
        visit edit_account_activation_path(token, email: user.email)
        expect(current_path).to eq root_path
      end.to change(User, :count).by(1)
      expect(page).to have_selector('.dropdown', text: '設定')
      expect(page).to have_selector('.alert-success', text: 'ユーザー登録が完了しました')
    end
  end
end
