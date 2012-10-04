# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  # 由于很多 controller 与 view 都需要有登陆的判断操作, 所以在 Controller 的顶层引入 SessionsHelper
  include SessionsHelper

  def home
    redirect_to current_user if sign_in?
  end

  def help
  end
end
