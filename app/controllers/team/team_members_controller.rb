class Team::TeamMembersController < ApplicationController
  before_action :logged_in_user
  before_action :current_team_admin_user, except: %i[edit update]
  before_action :set_team_member, only: %i[edit update]
  before_action :set_member_orders, only: :edit_order
  before_action :team_member_current_team_page, only: :show
  before_action :team_member_display_name_correct_user, only: %i[edit update]

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

  def edit; end

  def update
    if @team_member.update(team_member_params)
      flash[:success] = 'メンバーの表示名を更新しました'
      redirect_to event_path(current_team)
    else
      render 'edit'
    end
  end

  def edit_order

  end

  def update_order
    @member_orders = member_orders_params.keys.each do |id|
      if member_order = TeamMember.find_by(id: id)
        member_order.update(member_orders_params[id])
      else
        flash[:danger] = 'メンバーが削除されています'
        redirect_to event_path(current_team)
        return
      end
    end
    flash[:success] = '表示順を変更しました'
    redirect_to event_path(current_team)
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

  def set_team_member
    @team_member = TeamMember.find(params[:id])
  end

  def set_member_orders
    @member_orders = TeamMember.includes(:user).where(team_id: Team.find_by(id: params[:id])).order(:event_order)
    return if @member_orders.present?

    redirect_to event_path(current_team)
  end

  def member_orders_params
    params.permit(team_members: [:event_order])[:team_members]
  end

  # 正しいチームメンバー一覧のページか確認し、違う場合は現在のチームのチームメンバー一覧ページにリダイレクトする
  def team_member_current_team_page
    return if (current_team.id == params[:id].to_i)

    redirect_to team_team_member_path(current_team)
  end

  def team_member_params
    params.require(:team_member).permit(:display_name)
  end

  # 正しいユーザーの出欠変更画面か確認し、違う場合はそのユーザーのチームのスケジュール管理画面にリダイレクトする
  def team_member_display_name_correct_user
    @team_member = TeamMember.find(params[:id])
    return if (@team_member && @team_member.user_id == current_user.id \
              || @team_member && Team.find(@team_member.team_id).admin_user_id == current_user.id)

    redirect_to event_path(current_team)
  end
end
