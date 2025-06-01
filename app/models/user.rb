class User < ApplicationRecord
  # saveする前に
  # 右辺のselfは省略できる
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  # 以下の正規表現は、メールアドレスの形式を検証するために使用される。
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  # 以下のものは、パスワードのセキュリティを強化するために使用される。
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }

  def User.digest(string)
    # costとは、BCryptのハッシュ化のコストを設定するために使用される。
    # もしmin_costなら少し抑えめにする。
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    # costは、ハッシュ化のコストを設定するために使用される。
    BCrypt::Password.create(string, cost: cost)
  end
end
