# -*- coding:utf-8 -*-
FactoryGirl.define do
  factory :user, class: User do |user|
    user.login 'test'
    user.email 'test@example.com'
    user.password 'test@example.com'
    user.sign_in_count 0
    user.created_at Time.now()
    user.updated_at Time.now()
    user.uid nil
    user.provider nil
  end
  factory :created_google_user, class: User do |user|
    user.login 'user@google.example.com'
    user.email 'unique-value@google.local'
    user.password 'qawsedrftgyhujikolp;'
    user.sign_in_count 1
    user.created_at Time.now()
    user.updated_at Time.now()
    user.uid 'unique-value'
    user.provider 'google'
  end
  factory :created_twitter_user, class: User do |user|
    user.login '@twittername'
    user.email 'unique-value@twitter.local'
    user.password 'qawsedrftgyhujikolp;'
    user.sign_in_count 1
    user.created_at Time.now()
    user.updated_at Time.now()
    user.uid 'unique-value'
    user.provider 'twitter'
  end
  factory :created_facebook_user, class: User do |user|
    user.login 'real name'
    user.email 'unique-value@facebook.local'
    user.password 'qawsedrftgyhujikolp;'
    user.sign_in_count 1
    user.created_at Time.now()
    user.updated_at Time.now()
    user.uid 'unique-value'
    user.provider 'facebook'
  end
  factory :created_openam_user, class: User do |user|
    user.login 'identity@openam'
    user.email 'unique-value@openam.local'
    user.password 'qawsedrftgyhujikolp;'
    user.sign_in_count 1
    user.created_at Time.now()
    user.updated_at Time.now()
    user.uid 'unique-value'
    user.provider 'openam'
  end
end
