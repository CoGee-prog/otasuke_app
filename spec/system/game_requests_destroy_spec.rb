require 'rails_helper'

RSpec.describe 'スケジュールから対戦相手検索テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member1, team: other_team1, user: other_user) }
  let!(:game_request) { FactoryBot.create(:game_request) }

  describe 'スケジュールから対戦相手検索の対戦申込削除のテスト' do
    it 'チームを検索し、スケジュール詳細画面に遷移して対戦申込を削除' do
      log_in_as(user)
      click_on 'スケジュールから対戦相手検索'
      expect(current_path).to eq search_schedule_teams_path
      fill_in 'event_team_search[day_time]', with: '002021-11-21-12:00'
      click_on '検索'
      expect(page).to have_content('イーグルス', count: 1)
      click_on 'スケジュール詳細'
      expect(current_path).to eq detail_schedule_team_path(other_team1)
      expect do
        click_on '対戦申込を取り消す'
      end.to change(GameRequest, :count).by(-1)
      expect(page).to have_selector('.alert-success', text: '対戦申込を取り消しました')
      expect(current_path).to eq detail_schedule_team_path(other_team1)
    end

    it '対戦を申し込まれたチームの対戦申込の削除' do
      log_in_as(other_user)
      click_on '試合リクエスト'
      expect(current_path).to eq game_request_path(other_team1)
      expect(page).to have_content('ファイターズ', count: 1)
      expect(page).to have_content('000-0000-0000', count: 1)
      expect(page).to have_content('よろしくお願いします！', count: 1)
      expect do
        click_on '試合リクエストを削除する'
      end.to change(GameRequest, :count).by(-1)
      expect(page).to have_selector('.alert-success', text: '試合リクエストを削除しました')
      expect(current_path).to eq game_request_path(other_team1)
    end
  end
end
