# -*- encoding : utf-8 -*-
#include SessionsHelper

# 模拟测试环境下登陆
def sign_in(user)
  visit signin_path
  fill_in 'session_email', with: user.email
  fill_in 'session_password', with: user.password
  check 'session_permanent'
  click_button "Sign in"
end
