class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update destroy]
  before_action :set_user, only: %i[edit update destroy]
  before_action :update_correct_user, only: :update
  before_action :edit_correct_user, only: :edit
  before_action :admin_user, only: :index
  before_action :delete_correct_user, only: :destroy

  def index
    @users = User.all.page(params[:page])
  end

  def destroy
    if @user.have_admin_teams.present?
      flash[:danger] = "チームの管理者であるためアカウントを削除できません。<br>
			管理者であるチームを全て削除してから再度行ってください。".html_safe
    else
      @user.destroy
      flash[:success] = 'ユーザーを削除しました'
    end
    current_user.admin? ? (redirect_to users_path) : (redirect_to root_path)
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

  def edit; end

  def update
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

  # 正しいユーザーかどうか確認する
  def update_correct_user
    redirect_to root_path unless current_user?(@user)
  end

  # 正しいユーザーの編集か確認し、違う場合はそのユーザーの編集画面にリダイレクトする
  def edit_correct_user
    redirect_to edit_user_path(current_user) unless current_user?(@user)
  end

  # 正しいユーザーの編集か確認し、違う場合はそのユーザーの編集画面にリダイレクトする
  def delete_correct_user
    redirect_to root_path unless current_user.admin? || current_user?(@user)
  end

  # 管理者ユーザーかどうか確認する
  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end
end
