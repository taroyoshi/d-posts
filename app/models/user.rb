class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts #models/micropost.rbのbelongs_to :userに対応
  
  has_many :following_relationships, class_name:  "Relationship",   #following_relationships という
                                    foreign_key: "follower_id",     #Relationshipクラスと同じ形で外部キーfollower_id
                                    dependent:   :destroy           #(Relationshipの)従属先のfollowerが削除されたらdestroy
  has_many :following_users, through: :following_relationships, source: :followed 
                                                                    #following_relationshipsを経由してfollowedを見るfollowing_usersの定義
  
  has_many :follower_relationships, class_name:  "Relationship",    #follower_relationships という
                                    foreign_key: "followed_id",     #Relationshipクラスと同じ形で外部キーfollowed_id
                                    dependent:   :destroy           #(Relationshipの)従属先のfollowedが削除されたらdestroy
  has_many :follower_users, through: :follower_relationships, source: :follower
                                                                    #follower_relationshipsを経由してfollowerを見るfollower_usersの定義

  
  #他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
  
  #自身の投稿とフォローしてるアカウントの投稿を取得
  #following_user_idsはhas_many :following_usersからの自動生成メソッド
  def feed_items 
    Micropost.where(user_id: following_user_ids + [self.id])
  end
  
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
                     
    #SQL : user_id IN (SELECT followed_id FROM relationships WHERE follower_id = :user_id) OR user_id = :user_id
  end
end
