# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  email      :string(255)
#  password   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  before do
    @user = User.create(name: "wyatt", email: "wppurking@gmail.com", password: "foo", password_confirmation: "foo")
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
end
