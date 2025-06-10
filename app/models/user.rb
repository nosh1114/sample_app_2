class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  # classは、micropostsのクラスを指定する。
  # 外部キーは、user_idを指定する。持っていることが前提。
  # 私がフォローしている方ね
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  # classは、Relationshipのクラス指定。
  # 外部キーは、followed_idを指定する。外部キーとは、他のテーブルのIDを参照するためのカラム。
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
  # followingは、active_relationshipsを通じて、followedを参照する。
  has_many :followers, through: :passive_relationships, source: :follower
  # sourceは、follower
  # saveする前に
  # 右辺のselfは省略できる
  # なぜこれをするのかというと、平文を保存するのではなく、
  # ハッシュ化されたパスワードを保存するため。
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  # 以下の正規表現は、メールアドレスの形式を検証するために使用される。
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  # 以下のものは、パスワードのセキュリティを強化するために使用される。
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  def self.digest(string)
    # costとは、BCryptのハッシュ化のコストを設定するために使用される。
    # もしmin_costなら少し抑えめにする。
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    # costは、ハッシュ化のコストを設定するために使用される。
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    # attr_accessorで定義したremember_tokenに値をセットする。
    self.remember_token = User.new_token
    # ここでuserのバリデーションを行わないようにするためにupdate_attributeを使用する。
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end
  # ここでremember_tokenが使えるのはattr_accessorで定義したから。
  def session_token
    remember_digest || remember
  end

    # 渡されたトークンがダイジェストと一致したらtrueを返す
    # 
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    # BCrypt::Password.newは、ハッシュ化されたパスワードを復号化するために使用される。
    # userにはremember_digestが保存されているので、ここに呼び出すことができる。
    # そして、remember_tokenがそのハッシュ化されたパスワードと一致するかどうかを確認する。
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  # ログアウト時に削除する。
  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    # reset_tokenを作成
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  # パスワードリセットのメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
             .includes(:user, image_attachment: :blob)
  end

    # ユーザーをフォローする
  def follow(other_user)
    # followingは配列である。
    following << other_user unless self == other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    following.delete(other_user)
  end

  # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private
  # メールアドレスをすべて小文字にする
  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
