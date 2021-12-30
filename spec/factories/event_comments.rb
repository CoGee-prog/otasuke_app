FactoryBot.define do
  factory :event_comment, class: 'EventComment' do
    comment { "しばらく行けないです" }
    user_id { 1 }
    team_id { 1 }
  end

  factory :not_admin_user_event_comment, class: 'EventComment' do
    comment { "来週から参加します" }
    user_id { 3 }
    team_id { 1 }
  end
end
