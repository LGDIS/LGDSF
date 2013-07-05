# -*- coding:utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TODO : adminでログインするため一次的に対応（結合時に削除する）
User.find_by_sql("insert into users (login, email, encrypted_password, created_at, updated_at, confirmed_at) values('admin', 'admin@gmail.example.com', '$2a$10$iYGZzQPGW0Ig1S.bblPsaeeIicuRyXMzs/O.EcaU3vT0KRSF56E7C', now(), now(), now())")

# User.create!(:login => 'testtest', :email => 'test@example.jp', :password => 'test@example.jp', :confirmed_at => Time.now)


