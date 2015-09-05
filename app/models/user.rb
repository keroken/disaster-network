class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  before_save { self.email = email.downcase }
  
#  validates :name, presence: true, length: { maximum: 50 }
#  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
#  validates :email, presence: true, length: { maximum: 255 },
#                    format: { with: VALID_EMAIL_REGEX },
#                    uniqueness: { case_sensitive: false }
#  has_secure_password

  validates :password, presence: false, on: :facebook_login

  def self.from_omniauth(auth)
      # emailの提供は必須とする
      user = User.where('email = ?', auth.info.email).first
    if user.blank?
      user = User.new
    end
  user.uid   = auth.uid
  user.name  = auth.info.name
  user.email = auth.info.email
  user.icon  = auth.info.image
  user.oauth_token      = auth.credentials.token
  user.oauth_expires_at = Time.at(auth.credentials.expires_at)
  user
  end
  
  has_many :microposts
  
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower
  
  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
  
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end

end
