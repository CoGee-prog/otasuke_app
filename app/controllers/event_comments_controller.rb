class EventCommentsController < ApplicationController
  before_action :logged_in_user
  def create
    @event_comment = current_user.event_comments.build(event_comment_params)
    if @event_comment.save
      flash[:success] = 'コメントを投稿しました'
      redirect_to event_path(current_team)
    else
      @team = Team.find(params[:event_comment][:team_id])
      @events = @team.events.includes(event_option: :event_option_entries, event_entries: :event_option_entry)
      render template: 'events/show'
    end
  end

  def destroy
    if (event_comment = EventComment.find_by(id: params[:id]))
      event_comment.destroy
      flash[:success] = 'コメントを削除しました'
    else
      flash[:danger] = 'コメントは既に削除されています'
    end
    redirect_to event_path(current_team)
  end

  private

  def event_comment_params
    params.require(:event_comment).permit(:comment, :team_id)
  end
end
