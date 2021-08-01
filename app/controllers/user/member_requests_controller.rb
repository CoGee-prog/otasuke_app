class User::MemberRequestsController < ApplicationController
  before_action :logged_in_user

  def create
    team = Team.find(params[:team_id])
    if TeamMember.find_by(team_id: team.id, user_id: current_user.id)
      flash[:danger] = '既にチームに所属しています'
      redirect_to teams_path
    else
      request = current_user.member_request.new(team_id: team.id, user_id: current_user.id)
      if request.save
        flash[:success] = 'チーム所属申請を送信しました'
        redirect_to teams_path
      else
        redirect_to root_path
      end
    end
  end

  def destroy
    team = Team.find(params[:id])
    request = current_user.member_request.find_by(team_id: team.id, user_id: current_user.id)
    if request
      request.destroy
      flash[:success] = 'チーム所属申請を取り消しました'
    else
      flash[:danger] = 'チーム所属申請がありません'
    end
    redirect_to teams_path
  end
end

private
