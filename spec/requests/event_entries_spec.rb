RSpec.describe 'EventEntries', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:not_admin_user) { FactoryBot.create(:not_admin_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: team, user: other_user) }
  let!(:team_member3) { FactoryBot.create(:team_member2, team: team, user: not_admin_user) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:event_entry) { EventEntry.find_by(user_id: user, event_id: event) }

  describe 'ログインしてないユーザーのスケジュール出欠アクションのテスト' do
    it 'スケジュール出欠編集からリダイレクトされる' do
      get edit_event_entry_path(user)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'スケジュール出欠更新からリダイレクトされる' do
      patch event_entry_path(user), params: { event_option_entries: { id: { feeling: 1 } } }
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe '存在しないスケジュール出欠の更新ができず、スケジュール管理画面にリダイレクトされる' do
    it 'スケジュール出欠更新からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      patch event_entry_path(user), params: { event_option_entries: { id: event_entry.event_option_entry.id + 1, feeling: 1 } }
      expect(flash[:success]).not_to eq '出欠を更新しました'
      expect(flash[:danger]).to eq 'スケジュールが削除されています'
      expect(response).to redirect_to event_path(team)
    end
  end

  describe '他のユーザーのスケジュール出欠の編集、更新が失敗する' do
    it 'スケジュール出欠編集からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      get edit_event_entry_path(user)
      expect(response).to redirect_to event_path(other_team1)
    end

    it 'スケジュール出欠更新からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      patch event_entry_path(user), params: { event_option_entries: { id: event_entry.event_option_entry.id, feeling: 1 } }
      expect(flash[:success]).not_to eq '出欠を更新しました'
      expect(response).to redirect_to event_path(other_team1)
    end
  end

  describe 'チーム管理者の場合、他のチームメンバーのスケジュール出欠の編集、更新に成功する' do
    it 'スケジュール出欠編集、更新が成功する' do
      post login_path params: { session: { email: user.email, password: user.password } }
      get edit_event_entry_path(other_user)
      patch event_entry_path(other_user), params: { event_option_entries: { id: { feeling: 1 } } }
      expect(flash[:success]).to eq '出欠を更新しました'
      expect(response).to redirect_to event_path(team)
    end
  end

  describe 'チーム管理者ではない場合、自分のスケジュール出欠の編集、更新に成功する' do
    it 'スケジュール出欠編集、更新が成功する' do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
      get edit_event_entry_path(not_admin_user)
      patch event_entry_path(not_admin_user), params: { event_option_entries: { id: { feeling: 1 } } }
      expect(flash[:success]).to eq '出欠を更新しました'
      expect(response).to redirect_to event_path(team)
    end
  end
end
