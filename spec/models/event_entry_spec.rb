RSpec.describe EventEntry, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, user: user, team: team) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:event_entry) { EventEntry.find_by(user_id: user, event_id: event) }

  describe 'スケジュール出欠の有効性のテスト' do
    it 'スケジュール出欠が有効である' do
      expect(event_entry).to be_valid
    end

    it 'スケジュール出欠のユーザーがない場合、無効である' do
      event_entry.user_id = ''
      expect(event_entry).not_to be_valid
    end

    it 'スケジュール出欠のイベントがない場合、無効である' do
      event_entry.event_id = ''
      expect(event_entry).not_to be_valid
    end

    it '1つのスケジュールに同じユーザーの出欠が2回以上保存されないこと' do
      event_entry = build(:event_entry, user_id: user, event_id: event)
      expect(event_entry).not_to be_valid
    end
  end
end
