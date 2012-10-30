class Relationship < ActiveRecord::Base
  attr_accessible :followed_id, :follower_id

  # 在 relationship 表中存在的用户之间的关系为 跟踪的人(follower) 与 被跟踪的人(followed)
  # 他们代表着用户与用户的跟踪关系之间的主动与被动的关系
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # 一个关系, 两者都不允许为空
  validates :follower, presence: true
  validates :followed, presence: true
end
