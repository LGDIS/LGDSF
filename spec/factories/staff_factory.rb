# -*- coding:utf-8 -*-
FactoryGirl.define do
  factory :staff1, class: Staff do |staff|
    staff.id 1
    staff.name '佐藤'
    staff.agent_id 1
    staff.destination_code '3'
    staff.status true
    staff.reason ''
    staff.latitude 38.415643
    staff.longitude 141.325893
    staff.created_at Time.now()
    staff.updated_at Time.now()
    staff.disaster_code '20130108151823978961'
  end
end
