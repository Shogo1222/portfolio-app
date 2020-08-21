# frozen_string_literal: true

class Message < ApplicationRecord
  validates :user_id, :to_user_id, :title, :body, presence: true

  belongs_to :user
end
