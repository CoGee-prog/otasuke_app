RSpec.describe 'ユーザーアカウント削除テスト', type: :system do
  let!(:other_user) { FactoryBot.create(:other_user) }

  describe '自分のアカウント削除' do
    it 'ログインし、自分のアカウントが削除できる' do
      log_in_as(other_user)
      click_on 'プロフィール編集'
      expect do
        click_on 'アカウント削除'
      end.to change(User, :count).by(-1)
      expect(page).to have_current_path root_path, ignore_query: true
      expect(page).to have_selector('.alert__success', text: 'アカウントを削除しました')
    end
  end
end
