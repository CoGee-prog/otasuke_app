class GameRequest < ApplicationRecord
  has_one_attached :image
  belongs_to :requesting_team, class_name: 'Team'
  belongs_to :requested_team, class_name:  'Team'
  validates :requesting_team_id, presence: true, uniqueness: { scope: :requested_team_id }
  validates :requested_team_id, presence: true
  validate :required_contact_address_or_image
  validates :contact_address, length: { maximum: 50 }
  validates :comment, length: { maximum: 255 }

  private

  # 連絡先か画像のどちらかが入力されていること
  def required_contact_address_or_image
    return if (contact_address.present? || image.present?)

    errors.add(:contact_address, '、LINEQRコード等はどちらか1つは必ず入力してください')
  end
end
