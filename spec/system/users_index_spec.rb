require 'rails_helper'

RSpec.describe 'ユーザー検索テスト', type: :system do
  let(:admin) { FactoryBot.create(:user) }
  let!(:users) { create_list(:users, 30) }
  it 'ユーザー管理者としてログインし、ユーザー削除ができる' do
    expect(User.count).to eq users.count
    log_in_as(admin)
    visit users_path
    expect(page).to have_css('.pagination')
    expect do
      click_link('削除', match: :first)
    end.to change(User, :count).by(-1)
    expect(current_path).to eq users_path
    expect(page).to have_selector('.alert-success', text: 'ユーザーを削除しました')
  end
end
