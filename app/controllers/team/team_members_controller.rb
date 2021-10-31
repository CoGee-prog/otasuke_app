class Team::TeamMembersController < ApplicationController
  before_action :logged_in_user
  before_action :current_team_admin_user
  before_action :team_member_current_team_page, only: :show

  def show
    @members = Team.find(params[:id]).team_members.all.page(params[:page])
  end

  def create
    if (@request = MemberRequest.find_by(id: params[:id]))
      @team = Team.find(@request.team_id)
      if (@team.admin_user_id == current_user.id)
        user = User.find(@request.user_id)
        @belong = @team.team_members.new(user_id: user.id)
        if @belong.save
          @request.destroy
          user.current_team_id = @team.id
          user.save
          flash[:success] = 'チーム所属申請を承認しました'
        else
          flash[:danger] = '不正な値です'
        end
        redirect_to team_member_request_path(@team)
      else
        redirect_to root_path
      end
    else
      flash[:danger] = '既に削除されているか存在しないメンバーリクエストです'
      redirect_to team_member_request_path(current_team)
    end
  end

  def destroy
    if (belong = TeamMember.find_by(id: params[:id]))
      team = Team.find(belong.team_id)
      if (team.admin_user_id == current_user.id)
        user = User.find(belong.user_id)
        belong.destroy
        user.current_team_id = nil
        user.save
        flash[:success] = 'メンバーを削除しました'
      else
        redirect_to root_path
        return
      end
    else
      flash[:danger] = '既に削除されているか存在しないメンバーです'
    end
    redirect_to team_team_member_path(current_team)
  end

  private

  def team_member_current_team_page
    return if (current_team.id == params[:id].to_i)

    redirect_to team_team_member_path(current_team)
  end

  def team_member_team_admin_user
    @request = MemberRequest.find_by(id: params[:id])
    @team = Team.find(@request.team_id)
  end
end
