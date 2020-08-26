FactoryBot.define do
  factory :notification do
    user_id { 0 }
    is_opened { false }
    action_from { 'MyString' }
    invitation_id { 0 }
    follow_relationship_id { 0 }
  end
end
