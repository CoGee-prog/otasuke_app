require 'rails_helper'

RSpec.describe MemberRequest, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:team) { FactoryBot.create(:team) }
  let!(:member_request1) { FactoryBot.create(:member_request1, user: user, team: team) }

  describe 'チームリクエストの有効性のテスト' do
    it 'メンバーリクエストが有効である' do
      expect(member_request1).to be_valid
    end

    it 'ユーザーがない場合、無効である' do
      member_request1.user_id = ''
      expect(member_request1).not_to be_valid
    end

    it 'チームがない場合、無効である' do
      member_request1.team_id = ''
      expect(member_request1).not_to be_valid
    end

    it '1つのチームへのチームリクエストに同じユーザーが2回以上保存されないこと' do
      member_request = build(:member_request1, user: user, team: team)
      expect(member_request).not_to be_valid
    end
  end
end
