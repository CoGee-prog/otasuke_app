module PasswordResetHelper
  # パスワード再設定メールを送る
  def password_reset_as(user)
    visit new_password_reset_path
    fill_in 'password_reset[email]', with: user.email
    click_on '送信する'
  end
end
