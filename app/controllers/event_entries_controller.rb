class EventEntriesController < ApplicationController
  before_action :logged_in_user
  before_action :event_entry_correct_user_team

  def edit
    @event_entry = EventEntry.find(params[:id])
    @event = Event.find(@event_entry.event_id)
  end

  def update
    @event_entry = EventEntry.find(params[:id])
    @event = Event.find(@event_entry.event_id)
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

  def event_entry_correct_user_team
    @event_entry = EventEntry.find_by(id: params[:id])
    return if @event_entry && @event_entry.user_id == current_user.id && Event.find(@event_entry.event_id).team_id == current_team.id

    redirect_to event_path(current_team)
  end
end
