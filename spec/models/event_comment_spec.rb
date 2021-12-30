require 'rails_helper'

RSpec.describe EventComment, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, user: user, team: team) }
  let!(:event_comment) { FactoryBot.build(:event_comment) }

  describe 'スケジュールの有効性のテスト' do
    it 'スケジュールが有効である' do
      expect(event_comment).to be_valid
    end

    it 'コメントがない場合、無効である' do
      event_comment.comment = ''
      expect(event_comment).not_to be_valid
    end

    it 'コメントが長すぎる場合、無効である' do
      event_comment.comment = 'a' * 51
      expect(event_comment).not_to be_valid
    end

  end
end
