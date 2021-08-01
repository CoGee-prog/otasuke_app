require 'rails_helper'
RSpec.describe 'Teams', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }

  describe 'ログインしてないユーザーのチームアクションのテスト' do
    it 'チーム生成からリダイレクトされる' do
      get new_team_path
      expect(flash[:danger]).to eq 'ログインしてください'
      expect(response).to redirect_to login_path
    end

    it 'チーム作成からリダイレクトされる' do
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
      delete team_path(team)
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
  end

  describe 'チーム管理者ユーザー以外からのチームプロフィール編集が失敗する' do
    it 'チーム編集からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      get edit_team_path(team)
      expect(response).to redirect_to root_path
    end

    it 'チーム更新からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      patch team_path(team), params: { team: { name: 'イーグルス', level: team.level, prefecture_id: team.prefecture_id,\
                                               activity_monday: team.activity_monday, activity_tuesday: team.activity_tuesday,\
                                               activity_wednesday: team.activity_wednesday, activity_thursday: team.activity_thursday,\
                                               activity_friday: team.activity_friday, activity_saturday: team.activity_saturday,\
                                               activity_sunday: team.activity_sunday } }
      expect(flash[:success]).not_to eq 'チームプロフィールを更新しました'
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

    it 'ログインしていないユーザーの場合、削除からリダイレクトされる' do
      expect do
        delete team_path(team)
      end.not_to change(Team, :count)
      expect(response).to redirect_to login_path
    end

    it 'チーム管理者ではないユーザーの場合、削除からリダイレクトされる' do
      post login_path params: { session: { email: other_user.email, password: other_user.password } }
      expect do
        delete team_path(team)
      end.not_to change(Team, :count)
      expect(response).to redirect_to root_path
    end
  end
end
