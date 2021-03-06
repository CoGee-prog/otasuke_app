RSpec.describe 'Events', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:not_admin_user) { FactoryBot.create(:not_admin_user) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: not_admin_user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: other_team1, user: other_user) }

  describe 'ログインしてないユーザーのスケジュールアクションのテスト' do
    it 'スケジュール作成からリダイレクトされる' do
      get new_event_path
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'スケジュール登録からリダイレクトされる' do
      post events_path, params: { event: { day_time: event.day_time, ground: event.ground,\
                                           opponent_team_name: event.opponent_team_name, other: event.other } }
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'スケジュール編集からリダイレクトされる' do
      get edit_event_path(event)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'スケジュール更新からリダイレクトされる' do
      patch event_path(event), params: { event: { day_time: event.day_time, ground: event.ground,\
                                                  opponent_team_name: event.opponent_team_name, other: event.other } }
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'スケジュール削除からリダイレクトされる' do
      expect do
        delete event_path(event)
      end.not_to change(Event, :count)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'スケジュール管理からリダイレクトされる' do
      get event_path(team)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end
  end

  describe 'チーム管理者ユーザー以外からのスケジュール作成、登録、編集、更新、削除が失敗する' do
    before do
      post login_path params: { session: { email: not_admin_user.email, password: not_admin_user.password } }
    end

    it 'スケジュール作成からリダイレクトされる' do
      get new_event_path
      expect(response).to redirect_to root_path
    end

    it 'スケジュール登録からリダイレクトされる' do
      expect do
        post events_path, params: { event: { day_time: event.day_time, ground: event.ground,\
                                             opponent_team_name: event.opponent_team_name, other: event.other } }
      end.not_to change(Event, :count)
      expect(flash[:success]).not_to eq 'スケジュールを登録しました'
      expect(response).to redirect_to root_path
    end

    it 'スケジュール編集からリダイレクトされる' do
      get edit_event_path(event)
      expect(response).to redirect_to event_path(team)
    end

    it 'スケジュール更新からリダイレクトされる' do
      patch event_path(event), params: { event: { day_time: event.day_time, ground: event.ground,\
                                                  opponent_team_name: event.opponent_team_name, other: event.other } }
      expect(flash[:success]).not_to eq 'スケジュールを更新しました'
      expect(response).to redirect_to event_path(team)
    end

    it 'スケジュール削除からリダイレクトされる' do
      expect do
        delete event_path(event)
      end.not_to change(Event, :count)
      expect(response).to redirect_to event_path(team)
    end
  end

  describe 'チームに所属していない別のチームの管理者のテスト' do
    before do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
    end
    it 'スケジュール管理画面から現在のチームのスケジュール管理画面にリダイレクトされる' do
      get event_path(team)
      expect(response).to redirect_to event_path(other_user.current_team_id)
    end

    it 'スケジュール編集から現在のチームのスケジュール管理画面にリダイレクトされる' do
      get edit_event_path(event)
      expect(response).to redirect_to event_path(other_user.current_team_id)
    end

    it 'スケジュール更新から現在のチームのスケジュール管理画面にリダイレクトされる' do
      patch event_path(event), params: { event: { day_time: event.day_time, ground: event.ground,\
                                                  opponent_team_name: event.opponent_team_name, other: event.other } }
      expect(flash[:success]).not_to eq 'スケジュールを更新しました'
      expect(response).to redirect_to event_path(other_user.current_team_id)
    end

    it 'スケジュール削除から現在のチームのスケジュール管理画面にリダイレクトされる' do
      expect do
        delete event_path(event)
      end.not_to change(Event, :count)
      expect(flash[:success]).not_to eq 'スケジュールを削除しました'
      expect(response).to redirect_to event_path(other_user.current_team_id)
    end
  end
end
