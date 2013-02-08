# -*- coding:utf-8 -*-
FactoryGirl.define do
  factory :user, class: User do |user|
    user.id 1
    user.email 'test@test.jp'
    user.password '$2a$10$0iAbpBeE3lpJZZhJO5/v0egvI0OYrmXuu1YLhKMroynkQnTRsVggq'
    user.sign_in_count 0
    user.created_at Time.now()
    user.updated_at Time.now()
  end
end
