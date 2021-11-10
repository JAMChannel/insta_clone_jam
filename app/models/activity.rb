class Activity < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :subject, polymorphic: true
  belongs_to :user

  scope :recent, ->(count) { order(created_at: :desc).limit(count)}

  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }
  enum read: { unread: false, read: true }

  def redirect_path
    case action_type.to_sym
    when :commented_to_own_post
      post_path(subject.post, anchor: "comment-#{subject.id}")
    when :liked_to_own_post
      post_path(subject.post)
    when :followed_me
      user_path(subject.follower)
    end
  end
end
