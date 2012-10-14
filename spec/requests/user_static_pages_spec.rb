# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "User page" do
  subject { page }

  before { @user = FactoryGirl.create(:user) }

  describe "un sign in" do

    describe "visit user edit page" do
      before { visit edit_user_url(@user) }

      it "should redirect_to sigin page" do
        should have_selector("div.alert", text: "请先登陆")
        should have_content("永久登陆")
      end

      it "should redirect_to user edit page" do
        fill_in 'session_email', with: @user.email
        fill_in 'session_password', with: @user.password
        click_button 'Sign in'

        # 在写另外一个测试登陆后修改其他用户的测试方法的时候发现,
        # 对于 should have_content 方法, 默认只能作用与 before 中进行了页面访问,
        # 例如 "should redirect_to sigin page" 的测试
        # 而对于当前这个测试方法, 在方法内执行了 page 访问后, 不会作用与 subject 中的
        # page, 需要手动指定 page.body.should 来执行测试方法
        page.body.should have_content("Update your profile")
        page.body.should have_selector("input.btn")
      end

    end

    describe "signup page" do
      before { visit signup_url }

      describe "password valid" do
        before do
          fill_in 'user_name', with: 'wyatt'
          fill_in 'user_email', with: 'email@gmail.com'
        end

        it "should have 4 errors with blank password" do
          fill_in 'user_password', with: ''
          fill_in 'user_password_confirmation', with: ''
          click_button "Create my account"
          should have_content("表格中拥有 4 个错误")
          should have_selector("li", text: "Password digest can't be blank")
          should have_selector("li", text: "Password can't be blank")
          should have_selector("li", text: "Password is too short (minimum is 6 characters)")
          should have_selector("li", text: "Password confirmation can't be blank")
        end

        it "should have 2 errors with unconfirmation password" do
          fill_in 'user_password', with: '1'
          fill_in 'user_password_confirmation', with: '123'
          click_button "Create my account"
          should have_content("表格中拥有 2 个错误")
          should have_selector("li", text: "Password doesn't match confirmation")
          should have_selector("li", text: "Password is too short (minimum is 6 characters)")
        end
      end

    end

  end

  describe "sign in" do
    let(:admin_user) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }

    context "not admin" do
      before { sign_in(user) }

      it "edit another user should redirect to root path" do
        visit edit_user_path(admin_user)
        page.body.should have_selector("img", alt: user.name)
      end

    end

  end


end
