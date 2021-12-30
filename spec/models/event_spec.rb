RSpec.describe Event, type: :model do
  let!(:event) { FactoryBot.build(:event) }

  describe 'スケジュールの有効性のテスト' do
    it 'スケジュールが有効である' do
      expect(event).to be_valid
    end

    it '日時のないスケジュールの場合、無効である' do
      event.day_time = ''
      expect(event).not_to be_valid
    end

    it 'グラウンド名が長すぎる場合、無効である' do
      event.ground = 'a' * 51
      expect(event).not_to be_valid
    end

    it '対戦チーム名が長すぎる場合、無効である' do
      event.opponent_team_name = 'a' * 51
      expect(event).not_to be_valid
    end

    it '大会名が長すぎる場合、無効である' do
      event.tournament_name = 'a' * 51
      expect(event).not_to be_valid
    end

    it 'その他が長すぎる場合、無効である' do
      event.other = 'a' * 51
      expect(event).not_to be_valid
    end
  end
end
