class PasswordResetsController < ApplicationController
  before_action :set_user,   only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    if @user = User.find_by(email: params[:password_reset][:email].downcase)
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'パスワード再設定のメールを送信しました'
      redirect_to root_url
    else
      flash.now[:danger] = 'メールアドレスが見つかりません'
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = 'パスワードの再設定が完了しました'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # beforeアクション

  def set_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザーかどうか確認する
  def valid_user
    return if @user&.activated? &&
              @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  # トークンが期限切れかどうか確認する
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'パスワード再設定リンクの期限切れです'
    redirect_to new_password_reset_url
  end
end
