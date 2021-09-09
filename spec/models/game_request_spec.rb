RSpec.describe GameRequest, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:other_team1) { FactoryBot.create(:other_team1) }
  let!(:team_member1) { FactoryBot.create(:team_member1, team: team, user: user) }
  let!(:team_member2) { FactoryBot.create(:team_member2, team: other_team1, user: other_user) }
  let!(:game_request) { FactoryBot.create(:game_request) }

  describe '対戦申込の有効性のテスト' do
    it '対戦申込が有効である' do
      expect(game_request).to be_valid
    end

    it '連絡先とLINEQRコード等のない対戦申込の場合、無効である' do
      game_request.contact_address = ''
      expect(game_request).not_to be_valid
    end

    it '連絡先が長すぎる場合、無効である' do
      game_request.contact_address = 'a' * 51
      expect(game_request).not_to be_valid
    end

    it 'コメントが長すぎる場合、無効である' do
      game_request.comment = 'a' * 256
      expect(game_request).not_to be_valid
    end

    it '1つのチームへの対戦申込に同じチームが2回以上保存されないこと' do
      game_request2 = build(:game_request, requesting_team_id: game_request.requesting_team_id, \
                                           requested_team_id: game_request.requested_team_id, \
                                           contact_address: game_request.contact_address)
      expect(game_request2).not_to be_valid
    end
  end
end
