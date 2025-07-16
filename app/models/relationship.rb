class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  scope :recent_follow, ->{order(created_at: :desc)}
end
