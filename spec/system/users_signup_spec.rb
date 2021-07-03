require 'rails_helper'

RSpec.describe 'ユーザー登録テスト', type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  it '無効なユーザー登録' do
    visit root_path
    click_on '新規登録'
    expect(current_path).to eq signup_path
    expect do
      fill_in 'user[name]', with: ''
      fill_in 'user[email]', with: 'hoge@example.com'
      fill_in 'user[password]', with: 'hoge'
      fill_in 'user[password_confirmation]', with: 'fuga'
      click_on '登録する'
      expect(current_path).to eq users_path
    end.not_to change(User, :count)
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
      token = mail.text_part.body.encoded[/(?<=account_activations\/)[^\/]+/]
      visit edit_account_activation_path(token, email: user.email)
      expect(current_path).to eq root_path
    end.to change(User, :count).by(1)
    expect(has_css?('.dropdown')).to be_truthy
    expect(page).to have_selector('.alert-success', text: 'ユーザー登録が完了しました')
  end
end
