class Team::MemberRequestsController < ApplicationController
  before_action :logged_in_user
  before_action :team_admin_user, only: :show

  def show
    @requests = Team.find(params[:id]).member_request.all.page(params[:page])
  end

  def destroy
    @request = MemberRequest.find_by(id: params[:id])
    if @request
      @team = Team.find(@request.team_id)
      if @team.admin_user_id == current_user.id
        @request.destroy
        flash[:success] = 'チーム所属申請を拒否しました'
        redirect_to team_member_request_path(@team)
      else
        redirect_to root_path
      end
    else
      flash[:danger] = '既に削除されたか存在しないメンバーリクエストです'
      redirect_to team_member_request_path(current_team)
    end
  end
end
