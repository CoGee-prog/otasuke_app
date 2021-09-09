RSpec.describe 'パスワードの再設定', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  before do
    ActionMailer::Base.deliveries.clear
  end

  describe 'パスワード再設定メールを送信するまで' do
    it 'パスワード再設定画面にアクセスする' do
      visit root_path
      click_on 'ログイン'
      click_on 'パスワードをお忘れですか？'
      expect(current_path).to eq new_password_reset_path
    end

    it 'メールアドレスが無効な場合' do
      visit new_password_reset_path
      fill_in 'password_reset[email]', with: ''
      click_on '送信する'
      expect(page).to have_selector('.alert-danger', text: 'メールアドレスが見つかりません')
    end

    it 'メールアドレスが有効な場合' do
      password_reset_as(user)
      expect(user.reset_digest).not_to eq user.reload.reset_digest
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert-info', text: 'パスワード再設定のメールを送信しました')
    end
  end

  describe 'パスワード再設定フォームのテスト' do
    before do
      password_reset_as(user)
    end
    let(:mail) { ActionMailer::Base.deliveries.last }
    let(:reset_token) { mail.text_part.body.encoded[%r{(?<=password_resets/)[^/]+}] }

    it 'メールアドレスが無効' do
      visit edit_password_reset_path(reset_token, email: '')
      expect(current_path).to eq root_path
    end

    it '無効なユーザー' do
      user.update(activated: false)
      visit edit_password_reset_path(reset_token, email: user.email)
      expect(current_path).to eq root_path
    end

    it 'メールアドレスが有効で、トークンが無効' do
      visit edit_password_reset_path('wrong_token', email: user.email)
      expect(current_path).to eq root_path
    end

    it 'メールアドレスもトークンも有効' do
      visit edit_password_reset_path(reset_token, email: user.email)
      expect(current_path).to eq edit_password_reset_path(reset_token)
      expect(find('input[name=email][type=hidden]', visible: false).value).to eq user.email
    end

    it '無効なパスワードとパスワード確認' do
      visit edit_password_reset_path(reset_token, email: user.email)
      fill_in 'user[password]', with: 'hogehoge'
      fill_in 'user[password_confirmation]', with: 'fugafuga'
      click_on 'パスワードを更新する'
      expect(page).to have_selector('.form-alert-danger', text: 'パスワード（確認用）とパスワードの入力が一致しません')
    end

    it 'パスワードが空' do
      visit edit_password_reset_path(reset_token, email: user.email)
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''
      click_on 'パスワードを更新する'
      expect(page).to have_selector('.form-alert-danger', text: 'パスワードを入力してください')
    end

    it '有効なパスワードとパスワード確認' do
      visit edit_password_reset_path(reset_token, email: user.email)
      fill_in 'user[password]', with: 'hogehoge'
      fill_in 'user[password_confirmation]', with: 'hogehoge'
      click_on 'パスワードを更新する'
      expect(current_path).to eq root_path
      expect(page).to have_selector('.dropdown', text: '設定')
      expect(page).to have_selector('.alert-success', text: 'パスワードの再設定が完了しました')
    end
  end
end
