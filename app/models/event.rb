class Event < ApplicationRecord
    belongs_to :team
    has_many :event_entries, dependent: :destroy
    has_one :event_option, dependent: :destroy
    validates :day, presence: true
    validates :time, presence: true

    after_create :create_options
    after_create :create_event_entries
    

    private

    def create_options
        create_event_option
    end

    def create_event_entries
        self.team.team_members.each do |member|
            User.find(member.user_id).event_entries.create(event_id: self.id)
        end
    end


end
