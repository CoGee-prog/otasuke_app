class EventEntriesController < ApplicationController

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
        params.require(:event_entry).permit(event_option_entry_attributes: [:id, :feeling])
    end
end
