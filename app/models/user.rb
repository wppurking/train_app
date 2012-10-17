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
