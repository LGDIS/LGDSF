# -*- coding:utf-8 -*-
FactoryGirl.define do
  factory :agent1, class: Agent do |agent|
    agent.id 1
    agent.name '佐藤'
    agent.mail_address 'sato@gmail.com'
    agent.created_at Time.now()
    agent.updated_at Time.now()
  end
end
