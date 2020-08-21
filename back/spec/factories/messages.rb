FactoryBot.define do
  factory :message do
    user_id { "" }
    to_user_id { "MyString" }
    bigint { "MyString" }
    title { "MyString" }
    body { "MyString" }
  end
end
