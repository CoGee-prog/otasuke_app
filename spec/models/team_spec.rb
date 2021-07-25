require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:team) { FactoryBot.build(:team) }

  describe 'チームの有効性のテスト' do
    it 'チームが有効である' do
      expect(team).to be_valid
    end

    it '名前のないチームの場合、無効である' do
      team.name = ''
      expect(team).not_to be_valid
    end

    it 'チームレベルのないチームの場合、無効である' do
      team.level = ''
      expect(team).not_to be_valid
    end

    it '活動エリアのないチームの場合、無効である' do
      team.prefecture_id = ''
      expect(team).not_to be_valid
    end

    it '活動曜日のないチームの場合、無効である' do
      team.activity_saturday = ''
      team.activity_sunday = ''
      expect(team).not_to be_valid
    end

    it 'チーム名が長すぎる場合、無効である' do
      team.name = 'a' * 51
      expect(team).not_to be_valid
    end
  end
end
