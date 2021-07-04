require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    FactoryBot.build(:user)
  end

  it 'ユーザーが有効である' do
    expect(user).to be_valid
  end

  it '名前のないユーザーの場合、無効である' do
    user.name = ''
    expect(user).not_to be_valid
  end

  it 'メールアドレスのないユーザーの場合、無効である' do
    user.email = ''
    expect(user).not_to be_valid
  end

  it '名前が長すぎる場合、無効である' do
    user.name = 'a' * 51
    expect(user).not_to be_valid
  end

  it 'メールアドレスが長すぎる場合、無効である' do
    user.email = "#{'a' * 244}@example.com"
    expect(user).not_to be_valid
  end

  it '有効なメールアドレスを許可する' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} は有効になるべき"
    end
  end

  it '無効なメールアドレスを許可しない' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).not_to be_valid, "#{invalid_address.inspect} は無効になるべき"
    end
  end

  it 'メールアドレスは一意である' do
    duplicate_user = user.dup
    user.save
    expect(duplicate_user).not_to be_valid
  end

  it 'メールアドレスが小文字化されている' do
    mixed_case_email = 'UseR@EXApmPle.Com'
    user.email = mixed_case_email
    user.save
    expect(user.reload.email).to eq mixed_case_email.downcase
  end

  it 'パスワードが空の場合、無効である' do
    user.password = user.password_confirmation = ' ' * 6
    expect(user).not_to be_valid
  end

  it 'パスワードが最小の文字数を満たしていない場合、無効である' do
    user.password = user.password_confirmation = 'a' * 5
    expect(user).not_to be_valid
  end

  it 'remember_digestがnilならauthenticated?メソッドはfalseを返す' do
    expect(user.authenticated?(:remember, '')).to be_falsey
  end
end
