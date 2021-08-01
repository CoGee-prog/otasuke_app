require 'rails_helper'

RSpec.describe 'チーム登録テスト', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  it '無効なチーム登録' do
    log_in_as(user)
    click_on 'チーム作成'
    expect(current_path).to eq new_team_path
    expect do
      fill_in 'team[name]', with: ''
      click_on '登録する'
      expect(current_path).to eq teams_path
    end.not_to change(Team, :count)
  end

  it '有効なチーム登録' do
    log_in_as(user)
    click_on 'チーム作成'
    expect(current_path).to eq new_team_path
    expect do
      fill_in 'team[name]', with: 'ジャイアンツ'
      select '全国大会上位レベル', from: 'team[level]'
      select '東京', from: 'team[prefecture_id]'
      check 'team[activity_saturday]'
      check 'team[activity_sunday]'
      fill_in 'team[activity_frequency]', with: '週2回'
      fill_in 'team[homepage_url]', with: 'https//giants.com'
      fill_in 'team[other]', with: '精一杯頑張ります'
      click_on '登録する'
      expect(page).to have_selector('.alert-success', text: 'チームを作成しました')
      expect(current_path).to eq root_path
    end.to change(Team, :count).by(1)
    expect(page).to have_selector('.menu', text: 'ジャイアンツ')
  end
end
