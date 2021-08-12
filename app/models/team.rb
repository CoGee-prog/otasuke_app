class Team < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :users, through: :team_members
  has_many :member_requests, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :events, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  validates :level, presence: true
  validates :prefecture_id, presence: true
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

  validates :image, content_type: { in: %w[image/jpeg image/jpg image/gif image/png],
                                    message: "\b有効な画像形式のみ設定できます" },
                    size: { less_than: 5.megabytes,
                            message: '画像は5MB以下にしてください' }

  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(gravity: :center, resize: '100x100^', crop: '100x100+0+0')
  end

  # 検索機能
  def self.search(search)
    search ? where('name LIKE ?', "%#{search}%") : all
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
