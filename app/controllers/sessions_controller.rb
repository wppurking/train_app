# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  # 登陆页面
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    #user = User.where(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # 判断登陆正常以后, 将登陆信息放到 session 中
      session[:remember_token] = user.remember_token
      # 跳转到页面登陆页面
      redirect_to user
    else
      flash.now[:error] = user ? "密码错误" : "用户不存在"
      render 'new'
    end
  end

end
