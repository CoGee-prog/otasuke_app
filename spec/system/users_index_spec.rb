RSpec.describe 'ユーザー検索テスト', type: :system do
  let(:admin) { FactoryBot.create(:user) }
  let!(:users) { create_list(:users, 30) }

  describe '管理者によるユーザー削除' do
    it 'ユーザー管理者としてログインし、ユーザー削除ができる' do
      expect(User.count).to eq users.count
      log_in_as(admin)
      click_on 'ユーザー一覧'
      expect(page).to have_css('.pagination')
      expect do
        click_link('削除', match: :first)
      end.to change(User, :count).from(31).to(30)
      expect(current_path).to eq users_path
      expect(page).to have_selector('.alert-success', text: 'ユーザーを削除しました')
    end
  end
end
