class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'おたスケ メールアドレス認証'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'おたスケ パスワード再設定'
  end
end
