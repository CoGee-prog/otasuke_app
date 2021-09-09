RSpec.describe EventOption, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, user: user, team: team) }
  let!(:event) { FactoryBot.create(:event) }
  let!(:event_entry) { EventEntry.find_by(user_id: user, event_id: event) }
  let!(:event_option) { EventOption.find_by(event_id: event) }
  let!(:event_option_entry) { EventOptionEntry.find_by(event_option_id: event_option, event_entry_id: event_entry) }

  describe 'イベントオプションの有効性のテスト' do
    it 'event_optionが有効である' do
      expect(event_option).to be_valid
    end

    it 'イベントがない場合、無効である' do
      event_option.event_id = ''
      expect(event_option).not_to be_valid
    end

    it '同じスケジュールが2回以上保存されないこと' do
      event_option = build(:event_option, event_id: event)
      expect(event_option).not_to be_valid
    end
  end
end
