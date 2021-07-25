class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: %i[index destroy]

  def index
    @users = User.all.page(params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'ユーザーを削除しました'
    redirect_to users_path
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールを送信しました。<br>
      メールに記載されたURLをクリックして登録を完了してください。".html_safe
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'ユーザープロフィールを更新しました'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # beforeアクション

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  # 管理者ユーザーかどうか確認
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
