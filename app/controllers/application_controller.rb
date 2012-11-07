# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  # 由于很多 controller 与 view 都需要有登陆的判断操作, 所以在 Controller 的顶层引入 SessionsHelper
  include SessionsHelper

  def home
    if sign_in?
      @post = current_user.posts.build
      @user_posts = current_user.feeds.page(params[:page]).per(10)
    end
  end

  def help
  end
end
