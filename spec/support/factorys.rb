FactoryGirl.define do

  factory :user, class: User do
    name "wyatt"
    email "wppurking@gmail.com"
    password "foobar"
    password_confirmation "foobar"
  end

end