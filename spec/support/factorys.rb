# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :user, class: User do
    name "wyatt"
    sequence(:email) { |n| "wppurking#{n}@gmail.com" }
    password "foobar"
    password_confirmation "foobar"
    admin false


    factory :admin do
      admin true
    end
  end

end
