RSpec.describe 'イベントコメントテスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }

  it '無効なイベントコメント登録' do
    log_in_as(user)
    click_on 'スケジュール管理'
    expect(page).to have_current_path event_path(team), ignore_query: true
    expect do
      click_on 'コメントを投稿する'
    end.not_to change(EventComment, :count)
    expect(page).to have_selector('.form__alert--danger', text: 'コメントを入力してください')
    expect(page).to have_current_path event_comments_path, ignore_query: true
  end

  it '有効なイベントコメント登録' do
    log_in_as(user)
    click_on 'スケジュール管理'
    expect(page).to have_current_path event_path(team), ignore_query: true
    expect do
      fill_in 'event_comment[comment]', with: '今週は行けないです'
      click_on 'コメントを投稿する'
    end.to change(EventComment, :count).by(1)
    expect(page).to have_selector('.alert__success', text: 'コメントを投稿しました')
    expect(page).to have_current_path event_path(team), ignore_query: true
    expect(page).to have_selector('.comment-area', text: '【イチロー】 今週は行けないです')
  end
end
