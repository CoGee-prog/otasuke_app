RSpec.describe EventOptionEntry, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, user: user, team: team) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:event_entry) { EventEntry.find_by(user_id: user, event_id: event) }
  let!(:event_option) { EventOption.find_by(event_id: event) }
  let!(:event_option_entry) { EventOptionEntry.find_by(event_option_id: event_option, event_entry_id: event_entry) }

  describe 'イベント出欠オプションの有効性のテスト' do
    it 'event_option_entryが有効である' do
      expect(event_option_entry).to be_valid
    end

    it 'イベントオプションがない場合、無効である' do
      event_option_entry.event_option_id = ''
      expect(event_option_entry).not_to be_valid
    end

    it 'イベント出欠がない場合、無効である' do
      event_option_entry.event_entry_id = ''
      expect(event_option_entry).not_to be_valid
    end

    it 'feelingがない場合、無効である' do
      event_option_entry.feeling = ''
      expect(event_option_entry).not_to be_valid
    end

    it 'feelingが[0,1,2,3]以外の場合、無効である' do
      event_option_entry.feeling = 4
      expect(event_option_entry).not_to be_valid
    end
  end
end
