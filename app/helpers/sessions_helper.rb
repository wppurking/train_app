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
  end

  def sign_in?
    session.key?(:remember_token) || cookies.key?(:remember_token)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(session[:remember_token] ? session[:remember_token] : cookies[:remember_token])
  end

end
