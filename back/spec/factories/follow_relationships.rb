FactoryBot.define do
  factory :follow_relationship do
    user_id { "" }
    following_user_id { "" }
    is_mutual_follow { false }
  end
end
