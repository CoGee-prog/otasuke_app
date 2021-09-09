RSpec.describe 'ユーザー編集テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  describe 'ユーザープロフィールの編集' do
    it 'ユーザープロフィールの編集が失敗する' do
      log_in_as(user)
      visit edit_user_path(user)
      fill_in 'user[name]', with: ''
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: 'hoge'
      fill_in 'user[password_confirmation]', with: 'fuga'
      click_on '更新する'
      expect(page).to have_selector('.form-alert-danger', text: 'ニックネームを入力してください')
      expect(page).to have_selector('.form-alert-danger', text: 'メールアドレスを入力してください')
      expect(page).to have_selector('.form-alert-danger', text: 'パスワードは6文字以上で入力してください')
      expect(page).to have_selector('.form-alert-danger', text: 'パスワード（確認用）とパスワードの入力が一致しません')
      expect(current_path).to eq user_path(user)
    end

    it 'editのフレンドリーフォワーディングが成功し、ユーザープロフィールの編集が成功する' do
      visit edit_user_path(user)
      log_in_as(user)
      expect(current_path).to eq edit_user_path(user)
      name = 'hoge'
      email = 'hoge@example.com'
      fill_in 'user[name]', with: name
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''
      click_on '更新する'
      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert-success', text: 'ユーザープロフィールを更新しました')
      user.reload
      expect(user.name).to eq name
      expect(user.email).to eq email
    end

    it 'editのフレンドリーフォワーディングが成功した後、session[:forwarding_url]の値が削除されている' do
      visit edit_user_path(user)
      log_in_as(user)
      expect(current_path).to eq edit_user_path(user)
      click_on 'ログアウト'
      expect(page).to have_selector('.alert-success', text: 'ログアウトしました')
      log_in_as(user)
      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert-success', text: 'ログインしました')
    end
  end
end
