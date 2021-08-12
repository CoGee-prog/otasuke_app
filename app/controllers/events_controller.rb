class EventsController < ApplicationController
    def index

    end

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
        @events = Team.find(params[:id]).events
        @members = Team.find(params[:id]).team_members
    end

    def edit
        @event = Event.find(params[:id])
    end

    def update
        @event = Event.find(params[:id])
        if @event.update(event_params)
            flash[:success] = 'スケジュールを更新しました'
            redirect_to event_path(current_team)
        end
    end
    
    def destroy
        Event.find(params[:id]).destroy
        flash[:success] = 'スケジュールを削除しました'
        redirect_to event_path(current_team)
    end

    private

    def event_params
        params.require(:event).permit(:day, :time, :ground, :opponent_team_name, :tournament_name, :other)
    end
    
end
