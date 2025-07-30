class Micropost < ApplicationRecord
  CONTENT_LIMIT = 140
  IMAGE_RESIZE_LIMIT = [500, 500].freeze
  IMAGE_SIZE_LIMIT = Settings.default.image.SIZE_LIMIT # MBs
  IMAGE_PERMIT = %w(image/jpeg image/gif image/png).freeze

  MICROPOST_PERMIT = %i(
    content
    image
  ).freeze

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: IMAGE_RESIZE_LIMIT
  end

  belongs_to :user

  scope :recent_posts, -> {order(created_at: :desc)}
  scope :relate_post, -> (user_ids) do
    where(user_id: user_ids).order(created_at: :desc)
  end

  validates :content, presence: true, length: {maximum: CONTENT_LIMIT}

  validates :image,
            content_type: {
              in: IMAGE_PERMIT,
              message: lambda {|_object, _data|
                         I18n.t("microposts.image.not_permited")
                       }
            },
            size: {
              less_than: IMAGE_SIZE_LIMIT.megabytes,
              message: ->(_object, _data){I18n.t("microposts.image.too_big")}
            }

  def display_image
    image.variant(:display).processed
  end
end
