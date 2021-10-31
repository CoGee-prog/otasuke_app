class User::MemberRequestsController < ApplicationController
  before_action :logged_in_user

  def create
    @team = Team.find(params[:team_id])
    if TeamMember.find_by(team_id: @team.id, user_id: current_user.id)
      flash[:danger] = '既にチームに所属しています'
    else
      @request = current_user.member_requests.new(team_id: @team.id)
      if @request.save
        flash[:success] = 'チーム所属申請を送信しました'
      else
        redirect_to root_path
        return
      end
    end
    redirect_to teams_path
  end

  def destroy
    @team = Team.find(params[:id])
    if (@request = current_user.member_requests.find_by(team_id: @team.id))
      @request.destroy
      flash[:success] = 'チーム所属申請を取り消しました'
    else
      flash[:danger] = 'チーム所属申請がありません'
    end
    redirect_to teams_path
  end
end
