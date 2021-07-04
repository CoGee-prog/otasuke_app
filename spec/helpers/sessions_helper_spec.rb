require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe 'current_user' do
    let(:user) { FactoryBot.create(:user) }
    before do
      remember(user)
    end

    it 'sessionがnilの時current_userが正しく返ってくる' do
      expect(user).to eq current_user
      expect(logged_in?).to eq true
    end

    it 'remember_digestが間違っている時current_userがnilを返す' do
      user.update(remember_digest: User.digest(User.new_token))
      expect(current_user).to eq nil
    end
  end
end
