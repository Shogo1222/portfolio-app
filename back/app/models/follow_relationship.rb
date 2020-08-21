# frozen_string_literal: true

class FollowRelationship < ApplicationRecord
  validates :user_id, :following_user_id, :is_mutual_follow, presence: true

  belongs_to :user
end
