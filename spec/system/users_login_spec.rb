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
      visit root_path
      click_on 'ログイン'
      expect(current_path).to eq login_path
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      find('#login-btn').click
      expect(current_path).to eq root_path
      expect(has_css?('.dropdown')).to be_truthy
    end

    it '有効な情報でログインし、その後にログアウトする' do
      visit root_path
      click_on 'ログイン'
      expect(current_path).to eq login_path
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      find('#login-btn').click
      expect(current_path).to eq root_path
      expect(has_css?('.dropdown')).to be_truthy
      click_on 'ログアウト'
      expect(has_css?('.dropdown')).to be_falsey
    end
  end
end
