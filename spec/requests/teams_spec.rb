RSpec.describe 'Teams', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }

  describe 'ログインしてないユーザーのチームアクションのテスト' do
    it 'チーム作成からリダイレクトされる' do
      get new_team_path
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'チーム登録からリダイレクトされる' do
      post teams_path, params: { team: { name: team.name, level: team.level, prefecture_id: team.prefecture_id,\
                                         activity_monday: team.activity_monday, activity_tuesday: team.activity_tuesday,\
                                         activity_wednesday: team.activity_wednesday, activity_thursday: team.activity_thursday,\
                                         activity_friday: team.activity_friday, activity_saturday: team.activity_saturday,\
                                         activity_sunday: team.activity_sunday } }
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'チーム編集からリダイレクトされる' do
      get edit_team_path(team)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'チーム更新からリダイレクトされる' do
      patch team_path(team), params: { team: { name: 'イーグルス', level: team.level, prefecture_id: team.prefecture_id,\
                                               activity_monday: team.activity_monday, activity_tuesday: team.activity_tuesday,\
                                               activity_wednesday: team.activity_wednesday, activity_thursday: team.activity_thursday,\
                                               activity_friday: team.activity_friday, activity_saturday: team.activity_saturday,\
                                               activity_sunday: team.activity_sunday } }
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'チーム一覧からリダイレクトされる' do
      get teams_path
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'チーム削除からリダイレクトされる' do
      expect do
        delete team_path(team)
      end.not_to change(Team, :count)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'チーム詳細からリダイレクトされる' do
      get team_path(team)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it '所属チーム一覧からリダイレクトされる' do
      get list_team_path(user)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'チーム切り替えからリダイレクトされる' do
      post switch_team_path(team)
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it '対戦相手検索にアクセスできる' do
      get search_schedule_teams_path
      expect(response).to have_http_status(:ok)
    end

    it '対戦相手検索詳細にアクセスできる' do
      get detail_schedule_team_path(team)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'チーム管理者ユーザー以外からのチームプロフィール編集、更新、削除が失敗する' do
    before do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
    end

    it 'チーム編集からリダイレクトされる' do
      get edit_team_path(team)
      expect(response).to redirect_to edit_team_path(other_team1)
    end

    it 'チーム更新からリダイレクトされる' do
      patch team_path(team), params: { team: { name: 'イーグルス', level: team.level, prefecture_id: team.prefecture_id,\
                                               activity_monday: team.activity_monday, activity_tuesday: team.activity_tuesday,\
                                               activity_wednesday: team.activity_wednesday, activity_thursday: team.activity_thursday,\
                                               activity_friday: team.activity_friday, activity_saturday: team.activity_saturday,\
                                               activity_sunday: team.activity_sunday } }
      expect(flash[:success]).not_to eq 'チームプロフィールを更新しました'
      expect(response).to redirect_to root_path
    end

    it 'チーム削除からリダイレクトされる' do
      expect do
        delete team_path(team)
      end.not_to change(Team, :count)
      expect(response).to redirect_to root_path
    end
  end

  describe '他のユーザーの所属チーム一覧からリダイレクトされる' do
    before do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
    end

    it '間違ったユーザーがログインした時、所属チーム一覧からリダイレクトされる' do
      get list_team_path(user)
      expect(response).to redirect_to list_team_path(other_user)
    end

    it '所属していないチームへのチーム切り替えからリダイレクトされる' do
      post switch_team_path(team)
      expect(flash[:success]).not_to eq 'チームを切り替えました'
      expect(response).to redirect_to root_path
    end
  end

  describe 'チーム管理者属性に関するテスト' do
    it 'Web上でチーム管理者属性を編集できない' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect(team.admin_user_id).not_to eq other_user.id
      patch team_path(team), params: { team: { admin_user_id: other_user.id } }
      team.reload
      expect(team.admin_user_id).not_to eq other_user.id
    end
  end
end
