# -*- coding:utf-8 -*-
FactoryGirl.define do
  factory :user, class: User do |user|
    user.email 'test@test.jp'
    user.password 'test@test.jp'
    user.sign_in_count 0
    user.created_at Time.now()
    user.updated_at Time.now()
  end
end
