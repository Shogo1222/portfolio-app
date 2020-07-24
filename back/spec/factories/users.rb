# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test@gmail.com' }
    uid { '1234' }
    name { 'testuser' }
  end
end
