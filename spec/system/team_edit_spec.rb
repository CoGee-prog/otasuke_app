require 'rails_helper'

RSpec.describe 'チーム編集テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }

  it '無効なチーム編集' do
    visit root_path
    log_in_as user
    click_on 'ファイターズ'
    expect(current_path).to eq team_path(team)
    click_on '編集する'
    expect(current_path).to eq edit_team_path(team)
    fill_in 'team[name]', with: ''
    click_on '更新する'
    expect(page).to have_selector('.form-alert-danger', text: 'チーム名を入力してください')
    expect(current_path).to eq team_path(team)
  end

  it '有効なチーム登録' do
    visit root_path
    log_in_as user
    click_on 'ファイターズ'
    expect(current_path).to eq team_path(team)
    click_on '編集する'
    expect(current_path).to eq edit_team_path(team)
    fill_in 'team[name]', with: 'ジャイアンツ'
    click_on '更新する'
    expect(page).to have_selector('.alert-success', text: 'チームプロフィールを更新しました')
    expect(current_path).to eq team_path(team)
  end
end
