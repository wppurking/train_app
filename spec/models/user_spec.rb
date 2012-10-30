# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(30)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string(255)
#  admin           :boolean
#

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  before do
    @user = User.create(name: "wyatt", email: "wppurKing@gmail.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:email) }
  # 这两个是通过 has_secure_password 自动添加的
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  # 这个是需要用来存放 password 加密字符串的, 需要在数据库中存在
  it { should respond_to(:password_digest) }

  let(:errors) { @user.errors }
  it { errors.size.should == 0 }
  it { @user.new_record?.should == false }
  it { should respond_to(:password=) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  it { should respond_to(:followers) }
  it { should respond_to(:followeds) }
  it { should respond_to(:relationships) }

  describe "user email validation" do
    it "should be invalid" do
      emails = %w[user@foo,com user_aa_foo.org foo@foo+bar.cm]
      emails.each do |email|
        @user.email = email
        # be_xxx 自动调用 xxx? 方法, 因为是 bool 判断
        @user.should_not be_valid
      end
    end

    it "should be valid" do
      emails = %w[user@foo.com ba.kdjs@dfkj.com dosd+dkj@ggg.com wppurking@gmail.com]
      emails.each do |email|
        @user.email = email
        @user.should be_valid
      end
    end

    it "should be downcase" do
      @user.email.should == @user.email.downcase
    end
  end

  describe "user name validation" do
    it "should be invalid" do
      @user.name = "1" * 31
      @user.should_not be_valid
    end

    it "shoud be valid" do
      @user.name = "1" * 30
      @user.should be_valid
    end
  end

  describe "user password validation" do
    before { @un_save_user = User.new(name: "name", email: "email@gmail.com", password: '', password_confirmation: '') }
    it "should have 4 errors" do
      @un_save_user.valid?.should == false
      ["Password digest can't be blank",
       "Password can't be blank",
       "Password is too short (minimum is 6 characters)",
       "Password confirmation can't be blank"].each do |error|
        @un_save_user.errors.full_messages.include?(error).should == true
      end
    end
  end

  describe "user admin" do
    let(:admin_user) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }

    it "admin user should not be delete" do
      admin_user.destroy
      admin_user.errors.size.should == 1
      admin_user.errors.full_messages.include?("只有非管理员可以被删除")
    end
  end

  describe "user followed/follower users" do
    before do
      @user = FactoryGirl.create(:user)
      @other_user = FactoryGirl.create(:user)
      @user.follow(@other_user)
    end

    it "should have one followed user" do
      @user.followeds.size.should == 1
      @user.followeds[0].id.should == @other_user.id
    end

    it "should have one follower user" do
      @other_user.followers.size.should == 1
      @other_user.followers[0].id.should == @user.id
    end

    describe "user unfollow other user" do
      before do
        puts "Before......."
        @user.unfollow(@other_user)
      end

      it "should be no followeds" do
        @user.followeds.size.should == 0
      end

      it "should be no followers" do
        @other_user.followers.size.should == 0
      end
    end
  end
end
