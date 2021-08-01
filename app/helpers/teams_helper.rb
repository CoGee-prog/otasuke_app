module TeamsHelper
  def team_levels
    [%w[全国大会上位レベル 全国大会上位レベル], %w[全国大会出場レベル 全国大会出場レベル], %w[都道府県大会上位レベル 都道府県大会上位レベル],
     %w[都道府県大会出場レベル 都道府県大会出場レベル], %w[地区大会上位レベル 地区大会上位レベル], %w[地区大会参加レベル 地区大会参加レベル],
     %w[大会の参加経験はない 大会の参加経験はない], %w[試合経験はほぼない 試合経験はほぼない]]
  end

  def current_team
    @current_team ||= Team.find_by(id: current_user.current_team_id)
  end

  def current_team?(team)
    team && team == current_team
  end

  def belong_team?
    !current_team.nil? && !current_user.current_team_id.nil?
  end

  def weekly_columns
    %w[activity_monday activity_tuesday activity_wednesday
       activity_thursday activity_friday activity_saturday activity_sunday]
  end
end
