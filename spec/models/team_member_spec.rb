require 'rails_helper'

RSpec.describe TeamMember, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, user: user, team: team) }

  describe 'チームメンバーの有効性のテスト' do
    it 'チームメンバーが有効である' do
      expect(team_member1).to be_valid
    end

    it 'ユーザーがない場合、無効である' do
      team_member1.user_id = ''
      expect(team_member1).not_to be_valid
    end

    it 'チームがない場合、無効である' do
      team_member1.team_id = ''
      expect(team_member1).not_to be_valid
    end

    it '1つのチームに同じユーザーが2回以上保存されないこと' do
      team_member = build(:team_member1, user: user, team: team)
      expect(team_member).not_to be_valid
    end
  end
end
