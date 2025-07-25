class Micropost < ApplicationRecord
  belongs_to :user

  scope :newest, ->{order(created_at: :desc)}

  validates :content, presence: true, length: {maximum: 140}
end
