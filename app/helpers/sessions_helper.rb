# -*- encoding : utf-8 -*-
module SessionsHelper

  # 判断用户登陆后使用.
  # 用户登陆, 分永久登陆与浏览器有效期登陆
  def sign_in(user, permanent=false)
    if permanent
      session.delete(:remember_token)
      cookies.permanent[:remember_token] = user.remember_token
    else
      session[:remember_token] = user.remember_token
    end
    self.current_user = user
  end

  def sign_in?
    # 这种方法太不安全了, 只要 session 或者 cookies 中拥有就算登陆, 太不安全了 @_@
    # session.key?(:remember_token) || cookies.key?(:remember_token)

    # 还是使用登陆后的成员变量安全一些, 服务端的判断
    !self.current_user.nil?
  end

  def sign_out
    session.delete(:remember_token)
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(session[:remember_token] ? session[:remember_token] : cookies[:remember_token])
  end

  def redirect_back_to(default)
    # 登陆了判断是否有 back url, 有则返回
    if session.key?(:return_to)
      redirect_to session[:return_to]
      session.delete(:return_to)
    else
      redirect_to default
    end
  end

  private


  # 控制需要登陆的操作
  def require_login
    # 判断是否登陆了
    unless sign_in?
      # 没有登陆成功则跳回登陆页面, 并且记录返回链接
      session[:return_to] = request.url
      redirect_to signin_url, notice: "请先登陆"
    end
  end

end
