require 'rails_helper'

RSpec.describe TeamMember, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:team) { FactoryBot.create(:team) }
  let!(:team_member1) { FactoryBot.create(:team_member1, user: user, team: team) }

  it '1つのチームに同じユーザーが2回以上保存されないこと' do
    team_member = build(:team_member1, user: user, team: team)
    expect(team_member).not_to be_valid
  end
end
