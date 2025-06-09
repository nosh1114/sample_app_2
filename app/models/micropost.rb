class Micropost < ApplicationRecord
  belongs_to :user
  # imageメソッドを呼び出せるようになる。
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  default_scope -> { order(created_at: :desc) }
  # 必ず、micropostは、userに紐づくことから。
  validates :user_id, presence: true
  # からの投稿はできないとする。twitterのようにどれくらいの文字が投稿できるのかを。
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
end
