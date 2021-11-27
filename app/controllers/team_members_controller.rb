class TeamMembersController < ApplicationController
  before_action :logged_in_user
  before_action :team_member_display_name_correct_user

  def edit
    @team_member = TeamMember.find_by(user_id: params[:user_id], team_id: params[:team_id])
  end

  def update
    @team_member = TeamMember.find_by(user_id: params[:user_id], team_id: params[:team_id])
    if @team_member.update(team_member_params)
      flash[:success] = 'メンバーの表示名を更新しました'
      redirect_to event_path(current_team)
    else
      render 'edit'
    end
  end

  private

  def team_member_params
    params.require(:team_member).permit(:display_name)
  end

  # 正しいユーザーの出欠変更画面か確認し、違う場合はそのユーザーのチームのスケジュール管理画面にリダイレクトする
  def team_member_display_name_correct_user
    @team_member = TeamMember.find_by(user_id: params[:user_id], team_id: params[:team_id])
    return if (@team_member && @team_member.user_id == current_user.id \
              || @team_member && Team.find(@team_member.team_id).admin_user_id == current_user.id)

    redirect_to event_path(current_team)
  end
end
