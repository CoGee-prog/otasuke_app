class TeamsController < ApplicationController
  before_action :logged_in_user, except: %i[search_schedule detail_schedule]
  before_action :current_team_admin_user, only: :edit
  before_action :team_edit_current_team_page, only: :edit
  before_action :team_admin_user, only: %i[update destroy]
  before_action :set_team, only: %i[edit update switch destroy_image]
  before_action :currect_list_user, only: :list
  before_action :currect_switch_user, only: :switch

  def index
    @teams = Team.belong_team_search(params[:search]).page(params[:page])
  end

  def destroy
    Team.find(params[:id]).destroy
    flash[:success] = 'チームを削除しました'
    redirect_to root_path
  end

  def show
    return if (@team = Team.find_by(id: params[:id]))

    flash[:danger] = '対象のチームは削除されたか存在しないチームです'
    redirect_to root_path
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.admin_user_id = current_user.id
    if @team.save
      @team.image.attach(params[:team][:image]) if params[:team][:image]
      current_user.team_members.new(team_id: @team.id, user_id: current_user.id)
      current_user.current_team_id = @team.id
      current_user.save
      flash[:success] = 'チームを作成しました'
      redirect_to root_path
    else
      @team.image = nil
      render 'new'
    end
  end

  def edit; end

  def destroy_image
    @team.image.purge
    render 'edit'
  end

  def update
    if @team.update(team_params)
      @team.image.attach(params[:team][:image]) if params[:team][:image]
      flash[:success] = 'チームプロフィールを更新しました'
      redirect_to team_path(@team)
    else
      @team.image = nil
      render 'edit'
    end
  end

  def list
    @team_members = User.find(params[:id]).team_members
  end

  def switch
    current_user.current_team_id = Team.find(params[:id]).id
    current_user.save
    flash[:success] = 'チームを切り替えました'
    redirect_to event_path(current_team)
  end

  def search_schedule
    @event_search_params = event_search_params
    if logged_in? && current_team
      @teams = Team.where.not(id: current_team.id).event_team_search(@event_search_params).distinct.page(params[:page])
    else
      @teams = Team.event_team_search(@event_search_params).distinct.page(params[:page])
    end
  end

  def detail_schedule
    @team = Team.find(params[:id])
    @events = @team.events
    @game_request = GameRequest.new
  end

  private

  def team_params
    params.require(:team).permit(:image, :name, :level, :prefecture_id, :activity_monday, :activity_tuesday,
                                 :activity_wednesday, :activity_thursday, :activity_friday,
                                 :activity_saturday, :activity_sunday, :activity_frequency,
                                 :homepage_url, :other)
  end

  def event_search_params
    params.fetch(:event_team_search, {}).permit(:day_time, :prefecture_id, :level)
  end

  # beforeアクション

  def set_team
    @team = Team.find(params[:id])
  end

  # 正しいユーザーのチーム切り替え一覧か確認し、そのユーザーのチーム切り替え一覧画面にリダイレクトする
  def currect_list_user
    return if current_user.id == params[:id].to_i

    redirect_to list_team_path(current_user.id)
  end

  # 既に所属しているチームのチーム切り替えか確認する
  def currect_switch_user
    return if current_user.already_belong?(Team.find(params[:id]))

    redirect_to root_path
  end

  # 正しいチームの編集か確認し、現在のチームのチーム編集画面にリダイレクトする
  def team_edit_current_team_page
    return if current_team.id == params[:id].to_i

    redirect_to edit_team_path(current_team)
  end
end
