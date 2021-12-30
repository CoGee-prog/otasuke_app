class EventCommentsController < ApplicationController
  before_action :logged_in_user
  before_action :set_event_comment, only: :destroy
  before_action :event_comment_correct_user_team_page, only: :destroy

  def create
    @event_comment = current_user.event_comments.build(event_comment_params)
    if TeamMember.find_by(user_id: @event_comment.user_id, team_id: @event_comment.team_id)
      if @event_comment.save
        flash[:success] = 'コメントを投稿しました'
        redirect_to event_path(current_team)
      else
        @team = Team.find(params[:event_comment][:team_id])
        @events = @team.events.includes(event_option: :event_option_entries, event_entries: :event_option_entry)
        render template: 'events/show'
      end
    else
      redirect_to root_path
      nil
    end
  end

  def destroy
    if @event_comment&.destroy
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

  def set_event_comment
    @event_comment = EventComment.find_by(id: params[:id])
  end

  # 正しいユーザーのイベントコメントか、またはチーム管理者か確認し、ホーム画面にリダイレクトする
  def event_comment_correct_user_team_page
    return if (@event_comment.user_id == current_user.id || Team.find_by(id: @event_comment.team_id).admin_user_id == current_user.id)

    redirect_to root_path
  end
end
