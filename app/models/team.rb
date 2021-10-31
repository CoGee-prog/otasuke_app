require 'date'
class Team < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :team_members, dependent: :destroy
  has_many :users, through: :team_members
  has_many :member_requests, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :requesting_team, class_name: 'GameRequest', foreign_key: 'requesting_team_id', dependent: :destroy,
                             inverse_of: 'requesting_team'
  has_many :requested_team, class_name: 'GameRequest', foreign_key: 'requested_team_id', dependent: :destroy,
                            inverse_of: 'requested_team'
  validates :name, presence: true, length: { maximum: 50 }
  validates :level, presence: true
  validates :prefecture_id, presence: true
  validates :prefecture_id, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 47 },
                            allow_blank: true
  with_options inclusion: { in: [true, false] } do
    validates :activity_monday
    validates :activity_tuesday
    validates :activity_wednesday
    validates :activity_thursday
    validates :activity_friday
    validates :activity_saturday
    validates :activity_sunday
  end
  validate :weekly_checked
  validates :activity_frequency, length: { maximum: 50 }
  validates :homepage_url, length: { maximum: 255 }
  validates :other, length: { maximum: 255 }

  validates :image, content_type: { in: %w[image/jpeg image/jpg image/gif image/png],
                                    message: "\b有効な画像形式のみ設定できます" },
                    size: { less_than: 5.megabytes,
                            message: '画像は5MB以下にしてください' }

  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(gravity: :center, resize: '100x100^', crop: '100x100+0+0')
  end

  # 所属チーム検索機能
  scope :belong_team_search, ->(search) { where('name LIKE ?', "%#{search}%") }

  # 対戦相手検索機能
  scope :event_team_search, lambda { |event_search_params|
    return if event_search_params.blank?

    event_time_from_to(event_search_params[:day_time])
      .event_day_of_week(event_search_params[:day_time])
      .team_prefecture(event_search_params[:prefecture_id])
      .team_level(event_search_params[:level])
  }

  scope :event_time_from_to, lambda { |time|
    return if time.blank?

    exclude_ids = includes(:events).references(:events).where(events: \
    { day_time: DateTime.parse("#{time} JST") - 2.hours..DateTime.parse("#{time} JST") + 2.hours }).uniq.pluck(:id)
    where.not(id: exclude_ids)
  }
  scope :event_day_of_week, lambda { |day_of_week|
                              where("activity_#{DateTime.parse(day_of_week).strftime('%A').downcase} = ?", true) if day_of_week.present?
                            }
  scope :event_time_from, ->(time) { includes(:events).references(:events).merge(Event.time_from(time)) if time.present? }
  scope :event_time_to, ->(time) { includes(:events).references(:events).merge(Event.time_to(time)) if time.present? }
  scope :team_prefecture, ->(area) { where(prefecture_id: area) if area.present? }
  scope :team_level, ->(level) { where(level: level) if level.present? }
  scope :no_event, -> { where.missing(:events) }

  # 対戦リクエストを送っているかどうか
  def already_game_requested?(team)
    requesting_team.exists?(requested_team: team.id)
  end

  private

  # 曜日が1つ以上選択されていること
  def weekly_checked
    if activity_monday == false && activity_tuesday == false && activity_wednesday == false \
    && activity_thursday == false && activity_friday == false && activity_saturday == false && activity_sunday == false
      errors.add(:weekly, 'を1つ以上選択してください')
    end
  end
end
