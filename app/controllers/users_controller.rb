# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :require_login, only: [:edit, :update, :password, :change_password, :destroy]

  # 用户只能修改自己
  before_filter :correct_user, only: [:edit, :update]


  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "修改成功"
      sign_in(@user, !session.key?(:remember_token))
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      flash[:success] = "用户 #{user.name} 删除成功"
      redirect_to user
    else
      render 'index'
    end
  end

  def password
    @user = current_user
  end

  def change_password
    @user = current_user
    if @user.change_password(params[:user])
      # 验证通过
      sign_in(@user, !session.key?(:remember_token))
      flash[:success] = "密码修改成功"
      redirect_to password_path
    else
      # 验证失败
      flash.now[:error] = "修改密码失败" if not @user.errors.any?
      render 'password'
    end
  end

  private
  def correct_user
    user = User.find(params[:id])
    unless current_user?(user)
      flash[:error] = "不允许修改其他人的信息"
      redirect_to(root_path)
    end
  end

end
