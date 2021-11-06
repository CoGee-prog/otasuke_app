class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if (user&.authenticate(params[:session][:password]))
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = 'ログインしました'
        redirect_back_or root_path
      else
        flash[:warning] = "アカウントが有効ではありません。<br>
        メールに記載されたURLをクリックしてください。".html_safe
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが間違っています'
      render 'new'
    end
  end

  def create_google
    google_user = User.from_omniauth(request.env["omniauth.auth"])
    return unless (user = User.find_by(email: google_user.email))

      log_in user
      flash[:success] = 'ログインしました'
      redirect_to root_path
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'ログアウトしました'
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
