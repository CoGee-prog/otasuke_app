class GameRequestsController < ApplicationController
  before_action :logged_in_user
  before_action :current_team_admin_user
  before_action :game_request_current_team_page, only: :show

  def create
    @game_request = GameRequest.new(game_request_params)
    @game_request.requesting_team_id = current_team.id
    if @game_request.save
      @game_request.image.attach(params[:game_request][:image]) if params[:game_request][:image]
      flash[:success] = '対戦を申し込みました'
      redirect_to detail_schedule_team_path(@game_request.requested_team_id)
    else
      @game_request.image = nil
      @team = Team.find(params[:game_request][:requested_team_id])
      @events = @team.events
      render template: 'teams/detail_schedule'
    end
  end

  def destroy
    if (@game_request = GameRequest.find_by(id: params[:id]))
      if game_request_correct_team_admin_user(@game_request)
        @game_request.destroy
        flash[:success] = if (@game_request.requesting_team_id == current_team.id)
          '対戦申込を取り消しました'
                          else
                            '試合リクエストを削除しました'
        end
      else
        redirect_to root_path
        return
      end
    else
      flash[:danger] = '対戦申込は既に削除されています'
    end
    redirect_to request.referer
  end

  def show
    @game_requests = Team.find(params[:id]).requested_teams.page(params[:page])
  end

  private

  def game_request_params
    params.require(:game_request).permit(:contact_address, :comment, :image, :requested_team_id)
  end

  # beforeアクション

  # 試合リクエストが正しいチーム管理者のものか確認する
  def game_request_correct_team_admin_user(game_request)
    Team.find(game_request.requesting_team_id).admin_user_id == current_user.id \
    || Team.find(game_request.requested_team_id).admin_user_id == current_user.id
  end

  # 現在のチームの試合リクエスト一覧か確認し、違う場合は現在のチームの試合リクエスト一覧画面にリダイレクトする
  def game_request_current_team_page
    return if (current_team.id == params[:id].to_i)

    redirect_to game_request_path(current_team)
  end
end
