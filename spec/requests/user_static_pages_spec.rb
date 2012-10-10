# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "User page" do
  subject { page }

  before { @user = FactoryGirl.create(:user) }

  describe "un login" do

    describe "visit user edit page" do
      before { visit edit_user_url(@user) }

      it "should redirect_to sigin page" do
        should have_selector("div.alert", text: "请先登陆")
        should have_content("永久登陆")
      end

      it "should redirect_to user edit page" do
        fill_in 'session_email', with: 'wppurking@gmail.com'
        fill_in 'session_password', with: 'foobar'
        click_button 'Sign in'

        should have_content("Update your profile")
        should have_selector("input.btn")
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


end
