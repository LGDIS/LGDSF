# -*- coding:utf-8 -*-
FactoryGirl.define do
  factory :agent, class: Agent do |agent|
    agent.name '佐藤'
    agent.mail_address 'sato@gmail.example.com'
    agent.created_at Time.now()
    agent.updated_at Time.now()
  end
end
