# -*- coding:utf-8 -*-
FactoryGirl.define do
  factory :note, class: Note do |note|
    note.note '市長は無事です'
    note.staff_id 1
    note.created_at Time.now()
    note.updated_at Time.now()
  end
end
