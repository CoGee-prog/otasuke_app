require 'rails_helper'

RSpec.describe 'ユーザーログインテスト', type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe '無効な情報でのログイン' do
    it '空の情報でのログイン' do
      visit root_path
      click_on 'ログイン'
      expect(current_path).to eq login_path
      fill_in 'session[email]', with: ''
      fill_in 'session[password]', with: ''
      find('#login-btn').click
      expect(current_path).to eq login_path
      expect(has_css?('.alert-danger')).to be_truthy
      visit root_path
      expect(has_css?('.alert-danger')).to be_falsey
    end

    it 'メールアドレスは正しいが、パスワードが間違っている' do
      visit root_path
      click_on 'ログイン'
      expect(current_path).to eq login_path
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'hogehoge'
      find('#login-btn').click
      expect(current_path).to eq login_path
      expect(has_css?('.alert-danger')).to be_truthy
      visit root_path
      expect(has_css?('.alert-danger')).to be_falsey
    end
  end

  describe '有効な情報でのログイン' do
    it '有効な情報でのログイン' do
      log_in_as(user)
      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert-success', text: 'ログインしました')
      expect(has_css?('.dropdown')).to be_truthy
    end

    it '有効な情報でログインし、その後にログアウトする' do
      log_in_as(user)
      expect(current_path).to eq root_path
      expect(page).not_to have_link '新規登録'
      expect(page).not_to have_link 'ログイン'
      expect(has_css?('.dropdown')).to be_truthy
      expect(page).to have_selector('.alert-success', text: 'ログインしました')
      click_on 'ログアウト'
      expect(has_css?('.dropdown')).to be_falsey
      expect(page).to have_selector('.alert-success', text: 'ログアウトしました')
      # 2つ目のウィンドウでログアウトをクリックするユーザーのシュミレート
      delete logout_path
      follow_redirect!
      expect(page).to have_link '新規登録'
      expect(page).to have_link 'ログイン'
    end
  end

  describe 'ログイン状態の保持のテスト' do
    it 'ログイン状態を保持するを選択してログインする' do
      visit login_path
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      check 'ログイン状態を保持する'
      find('#login-btn').click
      expect(get_me_the_cookie('remember_token')).not_to eq nil
    end

    it 'ログイン状態を保持するを選択しないでログインする' do
      log_in_as(user)
      expect(get_me_the_cookie('remember_token')).to eq nil
    end
  end
end
