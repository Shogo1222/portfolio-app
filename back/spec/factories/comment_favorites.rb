# frozen_string_literal: true

FactoryBot.define do
  factory :comment_favorite do
    user_id { '1' }
    comment_id { '1' }
  end
end
