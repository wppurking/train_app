# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(30)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string(255)
#  admin           :boolean
#

# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # 这个是 rails 针对 mase-assignment 问题的白名单的解决办法
  # 将 password 与 password_confirmation 添加进入白名单, 是因为就算对这两个值进行了设置, 如果无法验证成功, 还是无法影响安全
  attr_accessible :email, :name, :password, :password_confirmation

  # 打开 secure_password.rb 查看后发现, 添加了 password_digest 的不为空检查, password 的 confirmation 检查, 所以
  # 这与我下面写的 "貌似只是自动添加了对 password_digest 为空的判断而已.." 并没有错.
  # 这个方法的作用, 有两个:
  #  1. 在为用户设置密码的时候(password=), 自动将没有加密的函数进行加密, 设置给 password_digest
  #  2. 添加用户的 authenticate 方法, 输入没有加密的密码, 其自动根据 password_digest 进行解密, 与密码比对
  has_secure_password

  # 向 Model 注册回掉函数有主要有两种方式
  # 1. 直接通过 before_save 注册一个 &block
  # 2. 使用 symbol 注册回掉函数的方法名
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  before_destroy :admin_check

  validates :email, presence: true, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: 30}

  # has_secure_password 文档中说,自动添加了 password, password_confirmation 但貌似是自动添加了对 password_digest 为空的判断而已...
  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true

  has_many :posts

  # 当前用户跟踪了很多人.
  # 将用户的跟踪分为 "跟踪者(follower) 与被跟踪者(followed)", 这里需要的关系是 N-N ,所以使用
  # has_many :through 来完成.  由于 follower 与 followed 的关系记录在 relationship 表中,
  # 所以需要通过 through: :relationship 来完成中间表的关联.
  # 默认情况下, 如果指定 foreign_key, 那么 User has_many relationships, 那么:
  # 1. 外键存储在 "多" 的一端
  # 2. 外键的名字为 user_id, 代表 relationships 通过 user_id 找到其关联的那一个 user
  # 由于现在 relationships 表中没有 user_id, 只有 follower_id 与 followed_id, 用来代表
  # 两个 user 之间的跟踪关系, 跟踪者的 id 与被跟踪者的 id, 并且这里需要寻找的是当前用户跟踪的人,
  # 也就是说, 在 relationships 表中, 当前用户是处于跟踪者的位置, 所以在 relationships 表中,
  # 当前用户寻找他的跟踪的人的时候, 是当前用户的 id 作为跟踪者的时候, 也就是 follower_id = user.id 的时候
  has_many :relationships, foreign_key: "follower_id"
  # 如果没有设置 source, 那么下面的语句则在通过 u.followeds 跟踪的用户的时候, 会
  # 到 relationships 表中通过与 relationships.followed/followeds 建立关系
  has_many :followeds, through: :relationships
  #has_many :followed_users, through: :relationships, source: "followed"

  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship"
  has_many :followers, through: :reverse_relationships

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  # 是否跟了此人
  def following?(user)
    relationships.find_by_followed_id(user.id) != nil
  end

  def unfollow(user)
    # TODO 非常奇怪, 在 rails c 中, 可以使用 user.relationships.where("followed_id=?", 3)
    # 这样执行: SELECT `relationships`.* FROM `relationships` WHERE `relationships`.`follower_id` = 1 AND (followed_id=3)
    # 获取到 relationships, 可在 rspc 中则只有使用 dynamic finder 才有效果?
    #relationships.where("followed_id=?", user.id).destroy
    relationships.find_by_followed_id(user.id).destroy

    # 区别 where 与动态 find_by 方法

    # > u.relationships.where('followed_id=?', 3)
    # Relationship Load (0.4ms)  SELECT `relationships`.* FROM `relationships` WHERE `relationships`.`follower_id` = 1
    # AND (followed_id=3)

    # > u.relationships.find_by_followed_id(3)
    #  Relationship Load (0.5ms)  SELECT `relationships`.* FROM `relationships` WHERE `relationships`.`follower_id` = 1
    # AND `relationships`.`followed_id` = 3 LIMIT 1
  end

  # 修改密码
  def change_password(options)
    return false if not options.is_a?(Hash)
    authenticate(options[:oldpassword]) && update_attributes(options.except(:oldpassword))
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  # 标记为管理员的用户不允许删除
  # 需要阻止在 destroy 继续执行, 返回 false 即可.
  # 同时可以将 erros 利用 add(:column, msg) 添加到 model.erros 中
  def admin_check
    errors.add(:admin, "只有非管理员可以被删除") if admin?
    !admin?
  end

end
