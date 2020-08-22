# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user_id { '1' }
    user_name { 'test' }
    logged_shop_id { '1' }
    shop_id { '1' }
    comment { 'commentTest' }
  end
end
