class EventsController < ApplicationController
  before_action :logged_in_user
  before_action :event_current_team_page, only: :show
  before_action :current_team_admin_user, only: %i[new create]
  before_action :set_event, only: %i[edit update destroy]
  before_action :currect_event_team_admin_user, only: %i[edit update destroy]

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
    @team = Team.includes(:users, :team_members).find(params[:id])
    @events = @team.events.includes(event_option: :event_option_entries, event_entries: :event_option_entry)
    @event_comment = EventComment.new
  end

  def edit
    return if @event

    flash[:danger] = 'スケジュールは既に削除されています'
    redirect_to event_path(current_team)
  end

  def update
    if @event
      if @event.update(event_params)
        flash[:success] = 'スケジュールを更新しました'
      else
        render 'edit'
        return
      end
    else
      flash[:danger] = 'スケジュールは既に削除されています'
    end
    redirect_to event_path(current_team)
  end

  def destroy
    if @event&.destroy
      flash[:success] = 'スケジュールを削除しました'
    else
      flash[:danger] = 'スケジュールは既に削除されています'
    end
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
    @event = Event.find_by(id: params[:id])
  end

  def currect_event_team_admin_user
    return if @event&.team.admin_user_id == current_user.id

    redirect_to event_path(current_team)
  end
end
