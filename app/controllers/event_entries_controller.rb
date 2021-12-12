class EventEntriesController < ApplicationController
  before_action :logged_in_user
  before_action :set_event_entry
  before_action :event_entry_correct_user_team_page

  def edit; end

  def update
    if @event_entry.update(entries_params)
      flash[:success] = '出欠を更新しました'
      redirect_to event_path(current_team)
    else
      render 'edit'
    end
  end

  private

  def entries_params
    params.require(:event_entry).permit(event_option_entry_attributes: %i[id feeling])
  end

  # beforeアクション

  def set_event_entry
    @event_entries = EventEntry.joins(:event).where(user_id: User.find(params[:id]), event: {team_id: current_team.id}).limit(2)
  end

  # 正しいユーザーのイベント出欠か、またはチーム管理者か確認し、違う場合は現在のチームのスケジュール管理ページにリダイレクトする
  def event_entry_correct_user_team_page
    @user = User.find_by(id: params[:id])
    return if (@user == current_user.id)
		@user.teams.each do |team|
			if team.admin_user_id == current_user.id
				return
			end
		end
    redirect_to event_path(current_team)
  end
end
