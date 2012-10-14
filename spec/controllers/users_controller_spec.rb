# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UsersController do

  describe "sign in" do
    let(:user) { FactoryGirl.create(:user) }
    let(:admin_user) { FactoryGirl.create(:admin) }

    describe "not admin" do

      it "update another user should redirect to root path" do
        sign_in(user)
        put :update, id: user, user: FactoryGirl.attributes_for(:admin)
        response.should redirect_to root_url
      end

    end
  end
end
