# frozen_string_literal: true

class UserTag < ApplicationRecord
  validates :user_id, :tag, presence: true

  belongs_to :user
end
