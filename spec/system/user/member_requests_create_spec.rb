require 'rails_helper'

RSpec.describe 'ユーザーのメンバーリクエスト作成テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }

  it 'チームに所属している場合はリクエストを送れない' do
    log_in_as(user)
    click_on '所属チーム検索'
    expect(current_path).to eq teams_path
    expect(page).to have_selector('.belonged', text: '所属済み')
  end

  it '所属リクエストを送った後に取消する' do
    log_in_as(other_user)
    click_on '所属チーム検索'
    expect(current_path).to eq teams_path
    expect do
      click_on '所属申請をする'
      expect(current_path).to eq teams_path
      expect(page).to have_selector('.alert-success', text: 'チーム所属申請を送信しました')
    end.to change(MemberRequest, :count).by(1)
    # 取り消す
    expect do
      click_on '申請を取り消す'
      expect(current_path).to eq teams_path
      expect(page).to have_selector('.alert-success', text: 'チーム所属申請を取り消しました')
    end.to change(MemberRequest, :count).by(-1)
  end
end
