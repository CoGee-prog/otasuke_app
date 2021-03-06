RSpec.describe 'スケジュール登録テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }

  it '無効なスケジュール登録' do
    log_in_as(user)
    click_on 'スケジュール管理'
    expect(page).to have_current_path event_path(team), ignore_query: true
    click_on '新しいスケジュールを登録する'
    expect do
      click_on '登録する'
    end.not_to change(Event, :count)
    expect(page).to have_selector('.form__alert--danger', text: '日時を入力してください')
    expect(page).to have_current_path events_path, ignore_query: true
  end

  it '有効なスケジュール登録' do
    log_in_as(user)
    click_on 'スケジュール管理'
    expect(page).to have_current_path event_path(team), ignore_query: true
    click_on '新しいスケジュールを登録する'
    expect do
      fill_in 'event[day_time]', with: '002021-11-01-10:00'
      fill_in 'event[ground]', with: '札幌ドーム'
      fill_in 'event[opponent_team_name]', with: 'イーグルス'
      fill_in 'event[tournament_name]', with: 'パ・リーグトーナメント'
      fill_in 'event[other]', with: '三塁側'
      click_on '登録する'
    end.to change(Event, :count).by(1)
    expect(page).to have_selector('.alert__success', text: 'スケジュールを登録しました')
    expect(page).to have_current_path event_path(team), ignore_query: true
    expect(page).to have_selector('#event', text: '11/01(月) 10:00 札幌ドーム VSイーグルス パ・リーグトーナメント 三塁側 編集 削除')
  end
end
