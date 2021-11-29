# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  avatar                  :string(255)
#  crypted_password        :string(255)
#  email                   :string(255)      not null
#  notification_on_comment :boolean          default(TRUE)
#  notification_on_follow  :boolean          default(TRUE)
#  notification_on_like    :boolean          default(TRUE)
#  salt                    :string(255)
#  username                :string(255)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :chatroom_users, dependent: :destroy
  has_many :chatrooms, through: :chatroom_users
  has_many :messages, dependent: :destroy

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  # new_record?はobjectが保存されていないときだけtrue
  # if: -> については、条件付きバリデーションのオプション特定の条件でバリデーションを行なうべきである場合に使う。(Railsガイド参照)
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  # passwordというDBに存在しない仮想的な属性(virtual attributes)が追加される。これがないと保存できない

  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  # ユーザーが「いいね!」したポスト一覧を取得
  # user.like_postsで投稿一覧を取得可能

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }
  has_many :activities, dependent: :destroy

  # 自身のものかを判別するためのメソッドを作成
  def own?(object)
    id == object.user_id
  end

  def like(post)
    # binding.pry
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    following.destroy(other_user)
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    Post.where(user_id: following_ids << id)
  end
end
