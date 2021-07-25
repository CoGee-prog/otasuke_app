require 'rails_helper'

RSpec.describe 'チーム切り替えテスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team) { FactoryBot.create(:other_team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, user: user, team: team) }
  let!(:team_member2) { FactoryBot.create(:team_member2, user: user, team: other_team) }

  it 'チームを切り替える' do
    visit root_path
    log_in_as user
    expect(page).to have_selector('.menu', text: 'ファイターズ')
    click_on 'チーム切り替え'
    expect(current_path).to eq list_team_path(user)
    click_on 'イーグルス'
    expect(current_path).to eq root_path
    expect(page).to have_selector('.menu', text: 'イーグルス')
  end
end
