class EventsController < ApplicationController
  before_action :logged_in_user
  before_action :event_current_team_page, only: :show
  before_action :current_team_admin_user, only: %i[new create edit update destroy]
  before_action :set_event, only: %i[edit update]

  def new
    @event = Event.new
  end

  def create
    @event = current_team.events.build(event_params)
    if @event.save
      flash[:success] = 'スケジュールを登録しました'
      redirect_to event_path(current_team)
    else
      render 'new'
    end
  end

  def show
    @team = Team.find(params[:id])
    @events = @team.events
    @members = @team.team_members
  end

  def edit; end

  def update
    if @event.update(event_params)
      flash[:success] = 'スケジュールを更新しました'
      redirect_to event_path(current_team)
    else
      render 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = 'スケジュールを削除しました'
    redirect_to event_path(current_team)
  end

  private

  def event_params
    params.require(:event).permit(:day_time, :ground, :opponent_team_name, :tournament_name, :other)
  end

  # beforeアクション

  # 現在のチームのスケジュール管理か確認し、違う場合は現在のチームのスケジュール管理画面にリダイレクトする
  def event_current_team_page
    return if current_team.id == params[:id].to_i

    redirect_to event_path(current_team)
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
