# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "用户注册成功"
      redirect_to @user
    elsif
      # 重新使用 new.html 进行渲染
      # errors 信息被记录在了 user model 身上
    render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

end
