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

    it '活動頻度が長すぎる場合、無効である' do
      team.activity_frequency = 'a' * 51
      expect(team).not_to be_valid
    end

    it 'チームHP等が長すぎる場合、無効である' do
      team.homepage_url = 'a' * 256
      expect(team).not_to be_valid
    end

    it 'その他が長すぎる場合、無効である' do
      team.other = 'a' * 256
      expect(team).not_to be_valid
    end

    it '活動エリアが1~47以外の場合、無効である' do
      team.prefecture_id = 48
      expect(team).not_to be_valid
    end

    it '活動エリアが整数以外の場合、無効である' do
      team.prefecture_id = 40.1
      expect(team).not_to be_valid
    end
  end
end
