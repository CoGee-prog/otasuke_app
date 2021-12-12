RSpec.describe 'EventEntries', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: team, user: other_user) }
  let!(:team_member3) { FactoryBot.create(:team_member3, team: other_team1, user: user) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:other_team_event1) { FactoryBot.create(:other_team_event1) }
  let!(:event_entry) { EventEntry.find_by(user_id: user, event_id: event) }
  let!(:other_user_event_entry) { EventEntry.find_by(user_id: other_user, event_id: event) }
  let!(:other_team_event_entry) { EventEntry.find_by(user_id: user, event_id: other_team_event1) }

  describe 'ログインしてないユーザーのスケジュール出欠アクションのテスト' do
    it 'スケジュール出欠編集からリダイレクトされる' do
      get edit_event_entry_path(event_entry)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'スケジュール出欠更新からリダイレクトされる' do
      patch event_entry_path(event_entry), params: { event_entry: { event_option_entry: { feeling: 1 } } }
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  xdescribe '他のユーザーのスケジュール出欠の編集、更新が失敗する' do
    it 'スケジュール出欠編集からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      get edit_event_entry_path(event_entry)
      expect(response).to redirect_to event_path(other_team1)
    end

    it 'スケジュール出欠更新からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      patch event_entry_path(event_entry), params: { event_entry: { event_option_entry: { feeling: 1 } } }
      expect(flash[:success]).not_to eq '出欠を更新しました'
      expect(response).to redirect_to event_path(other_team1)
    end
  end

  xdescribe 'チーム管理者の場合、他のチームメンバーのスケジュール出欠の編集、更新に成功する' do
    it 'スケジュール出欠編集、更新が成功する' do
      post login_path params: { session: { email: user.email, password: user.password } }
      get edit_event_entry_path(other_user_event_entry)
      patch event_entry_path(other_user_event_entry), params: { event_entry: { event_option_entry: { feeling: 1 } } }
      expect(flash[:success]).to eq '出欠を更新しました'
      expect(response).to redirect_to event_path(team)
    end
  end

  xdescribe '現在のチーム以外のスケジュール出欠テスト' do
    it '他のチームのスケジュール出欠編集からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      get edit_event_entry_path(other_team_event_entry)
      expect(response).to redirect_to event_path(team)
    end

    it '他のチームのスケジュール出欠更新からリダイレクトされる' do
      post login_path params: { session: { email: user.email, password: user.password } }
      patch event_entry_path(other_team_event_entry), params: { event_entry: { event_option_entry: { feeling: 1 } } }
      expect(flash[:success]).not_to eq '出欠を更新しました'
      expect(response).to redirect_to event_path(team)
    end
  end
end
