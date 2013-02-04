# -*- coding:utf-8 -*-
FactoryGirl.define do
  factory :user1, class: User do |user|
    user.id 1
    user.email 'test@test.jp'
    user.encrypted_password
    user.sign_in_count 0
    user.created_at Time.now()
    user.updated_at Time.now()
  end
end
