require 'rails_helper'

RSpec.describe 'チームのメンバーリクエスト削除テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:users) { create_list(:users, 30) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:member_requests) { create_list(:member_requests, 30) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }

  it '所属申請を拒否する' do
    expect(MemberRequest.count).to eq member_requests.count
    log_in_as(user)
    click_on '所属リクエスト'
    expect(page).to have_css('.pagination')
    expect(current_path).to eq team_member_request_path(team.id)
    expect do
      click_link('拒否する', match: :first)
      expect(current_path).to eq team_member_request_path(team.id)
      expect(page).to have_selector('.alert-success', text: 'チーム所属申請を拒否しました')
    end.to change(MemberRequest, :count).by(-1)
  end
end
