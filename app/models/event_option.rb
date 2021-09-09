class EventOption < ApplicationRecord
  belongs_to :event
  has_many :event_option_entries, dependent: :destroy
  validates :event_id, presence: true

  attr_accessor :count_ng, :count_neither, :count_ok

  # 出欠内容をカウントする
  def calc_event_option_entry
    feeling_counts = event_option_entries.group(:feeling).order(feeling: :asc).count
    self.count_ok      = feeling_counts['OK'] || 0
    self.count_neither = feeling_counts['Neither'] || 0
    self.count_ng      = feeling_counts['NG'] || 0
  end
end
