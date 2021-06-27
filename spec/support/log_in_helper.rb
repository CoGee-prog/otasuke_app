module LogInHelper
  # テストユーザーとしてログインする
  def log_in_as(user)
    visit login_path
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    find('#login-btn').click
  end

  # テストユーザーとしてログインする
  # def log_in(user)
  #     get login_path
  #     fill_in 'session[email]', with: user.email
  #     fill_in 'session[password]', with: user.password
  #     find('#login-btn').click
  # end
end
