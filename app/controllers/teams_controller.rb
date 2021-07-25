class TeamsController < ApplicationController
  before_action :logged_in_user
  before_action :team_admin_user, only: %i[edit update destroy]

  def index
    @teams = Team.all.search(params[:search]).page(params[:page])
  end

  def destroy
    Team.find(params[:id]).destroy
    flash.now[:success] = 'チームを削除しました'
    redirect_to root_path
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.admin_user_id = current_user.id
    if @team.save
      @team.image.attach(params[:team][:image]) if params[:team][:image]
      current_user.team_member.new(team_id: @team.id, user_id: current_user.id)
      current_user.current_team_id = @team.id
      current_user.save
      flash[:success] = 'チームを作成しました'
      redirect_back_or root_path
    else
      @team.image = nil
      render 'new'
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
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
    @team = @current_user.team_member
  end

  def switch
    @team = Team.find(params[:id])
    current_user.current_team_id = @team.id
    current_user.save
    flash[:success] = 'チームを切り替えました'
    redirect_to root_path
  end

  private

  def team_params
    params.require(:team).permit(:image, :name, :level, :prefecture_id, :activity_monday, :activity_tuesday,
                                 :activity_wednesday, :activity_thursday, :activity_friday,
                                 :activity_saturday, :activity_sunday, :activity_frequency,
                                 :homepage_url, :other)
  end

  def team_admin_user
    @team = Team.find(params[:id])
    redirect_to(root_path) unless @team.admin_user_id == current_user.id
  end
end
