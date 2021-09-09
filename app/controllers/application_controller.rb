class ApplicationController < ActionController::Base
  include SessionsHelper
  include TeamsHelper
  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'ログインしてください'
    redirect_to login_url
  end

  # チーム管理者かどうか確認
  def team_admin_user
    if (team = Team.find_by(id: params[:id]))
      redirect_to root_path unless team.admin_user_id == current_user.id
    else
      redirect_to root_path
    end
  end

  # 現在のチームの管理者かどうか確認
  def current_team_admin_user
    if (team = Team.find(current_team.id))
      redirect_to root_path unless team.admin_user_id == current_user.id
    else
      redirect_to root_path
    end
  end
end
