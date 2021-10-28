# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

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
end
