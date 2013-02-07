# -*- coding:utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:email => 'test@test.jp', :password => 'test@test.jp')

Agent.create(:name => '佐藤', :mail_address => 'sato@gmail.com')
Agent.create(:name => '鈴木', :mail_address => 'suzuki@gmail.com')
Agent.create(:name => '三重野', :mail_address => 'mieno@gmail.com')
Agent.create(:name => '中村', :mail_address => 'nakamura@gmail.com')
Agent.create(:name => '林', :mail_address => 'hayashi@gmail.com')

Agent.create(:name => '片本', :mail_address => 'katamoto@gmail.com')
Agent.create(:name => '安田', :mail_address => 'yasuda@gmail.com')
Agent.create(:name => '青木', :mail_address => 'aoki@gmail.com')
Agent.create(:name => '五十嵐', :mail_address => 'igarashi@gmail.com')
Agent.create(:name => '佐々木', :mail_address => 'sasaki@gmail.com')

Agent.create(:name => '塩谷', :mail_address => 'shiotani@gmail.com')
Agent.create(:name => '田辺', :mail_address => 'tanabe@gmail.com')
Agent.create(:name => '吉田', :mail_address => 'yoshida@gmail.com')
Agent.create(:name => '山本', :mail_address => 'yamamoto@gmail.com')
Agent.create(:name => '加藤', :mail_address => 'kato@gmail.com')

Agent.create(:name => '高橋', :mail_address => 'takahashi@gmail.com')
Agent.create(:name => '内村', :mail_address => 'uchimura@gmail.com')
Agent.create(:name => '田中', :mail_address => 'tanaka@gmail.com')
Agent.create(:name => '山田', :mail_address => 'yamada@gmail.com')
Agent.create(:name => '内田', :mail_address => 'uchida@gmail.com')

Agent.create(:name => '井上', :mail_address => 'inoue@gmail.com')
Agent.create(:name => '小林', :mail_address => 'kobayashi@gmail.com')
Agent.create(:name => '中村', :mail_address => 'nakamura@gmail.com')
Agent.create(:name => '伊藤', :mail_address => 'ito@gmail.com')
Agent.create(:name => '渡邊', :mail_address => 'watanabe@gmail.com')

Agent.create(:name => '斉藤', :mail_address => 'saito@gmail.com')
Agent.create(:name => '山口', :mail_address => 'yamaguchi@gmail.com')
Agent.create(:name => '松本', :mail_address => 'matumoto@gmail.com')
Agent.create(:name => '木村', :mail_address => 'kimura@gmail.com')
Agent.create(:name => '清水', :mail_address => 'simizu@gmail.com')

Agent.create(:name => '山崎', :mail_address => 'yamazaki@gmail.com')
Agent.create(:name => '池田', :mail_address => 'ikeda@gmail.com')
Agent.create(:name => '阿部', :mail_address => 'abe@gmail.com')
Agent.create(:name => '森', :mail_address => 'mori@gmail.com')
Agent.create(:name => '橋本', :mail_address => 'hashimoto@gmail.com')

Agent.create(:name => '山下', :mail_address => 'yamashita@gmail.com')
Agent.create(:name => '石川', :mail_address => 'ishikawa@gmail.com')
Agent.create(:name => '中島', :mail_address => 'nakazima@gmail.com')
Agent.create(:name => '前田', :mail_address => 'maeda@gmail.com')
Agent.create(:name => '小川', :mail_address => 'ogawa@gmail.com')

Agent.create(:name => '岡田', :mail_address => 'okada@gmail.com')
Agent.create(:name => '後藤', :mail_address => 'gotou@gmail.com')
Agent.create(:name => '長谷川', :mail_address => 'hasegawa@gmail.com')
Agent.create(:name => '村上', :mail_address => 'murakami@gmail.com')
Agent.create(:name => '遠藤', :mail_address => 'endo@gmail.com')

Staff.create(:name => '佐藤', :agent_id => 1, :destination_code => '3', :status => true, :latitude => 38.415643, :longitude => 141.325893, :disaster_code => "20130108151823978961")
Staff.create(:name => '鈴木', :agent_id => 2, :destination_code => '16', :status => true, :latitude => 38.452352, :longitude => 141.312504, :disaster_code => "20130108151823978961")
Staff.create(:name => '三重野', :agent_id => 3, :destination_code => '18', :status => true, :latitude => 38.43084, :longitude => 141.267872, :disaster_code => "20130108151823978961")
Staff.create(:name => '中村', :agent_id => 4, :destination_code => '', :status => false, :reason => '自宅倒壊', :latitude => 38.403133, :longitude => 141.290016, :disaster_code => "20130108151823978961")
Staff.create(:name => '林', :agent_id => 5, :destination_code => '3', :status => true, :latitude => 38.418602, :longitude => 141.367607, :disaster_code => "20130108151823978961")

Staff.create(:name => '片本', :agent_id => 6, :destination_code => '', :status => true, :latitude => 38.437388, :longitude => 141.339458, :disaster_code => "20130108151823978961")
Staff.create(:name => '安田', :agent_id => 7, :destination_code => '', :status => true, :disaster_code => "20130108151823978961")
Staff.create(:name => '青木', :agent_id => 8, :destination_code => '2', :status => true, :latitude => 38.42816, :longitude => 141.303531, :disaster_code => "20130108151823978961")
Staff.create(:name => '五十嵐', :agent_id => 9, :destination_code => '19', :status => true, :latitude => 38.445422, :longitude => 141.332392, :disaster_code => "20130108151823978961")
Staff.create(:name => '佐々木', :agent_id => 10, :destination_code => '5', :status => true, :latitude => 38.432396, :longitude => 141.303617, :disaster_code => "20130108151823978961")

Staff.create(:name => '塩谷', :agent_id => 11, :destination_code => '12', :status => true, :latitude => 38.449085, :longitude => 141.261324, :disaster_code => "20130108151823978961")
Staff.create(:name => '田辺', :agent_id => 12, :destination_code => '9', :status => true, :latitude => 38.431589, :longitude => 141.273104, :disaster_code => "20130108151823978961")
Staff.create(:name => '吉田', :agent_id => 13, :destination_code => '6', :status => true, :latitude => 38.424849, :longitude => 141.293081, :disaster_code => "20130108151823978961")
Staff.create(:name => '山本', :agent_id => 14, :destination_code => '10', :status => true, :latitude => 38.436245, :longitude => 141.310312, :disaster_code => "20130108151823978961")
Staff.create(:name => '加藤', :agent_id => 15, :destination_code => '1', :status => true, :latitude => 38.431976, :longitude => 141.301063, :disaster_code => "20130108151823978961")

Staff.create(:name => '高橋', :agent_id => 16, :destination_code => '13', :status => true, :latitude => 38.44527, :longitude => 141.30926, :disaster_code => "20130108151823978961")
Staff.create(:name => '内村', :agent_id => 17, :destination_code => '14', :status => true, :latitude => 38.442397, :longitude => 141.301171, :disaster_code => "20130108151823978961")
Staff.create(:name => '田中', :agent_id => 18, :destination_code => '15', :status => true, :latitude => 38.444565, :longitude => 141.290742, :disaster_code => "20130108151823978961")
Staff.create(:name => '山田', :agent_id => 19, :destination_code => '8', :status => true, :latitude => 38.43085, :longitude => 141.29351, :disaster_code => "20130108151823978961")
Staff.create(:name => '内田', :agent_id => 20, :destination_code => '4', :status => true, :latitude => 38.430295, :longitude => 141.295956, :disaster_code => "20130108151823978961")

Staff.create(:name => '井上', :agent_id => 21, :destination_code => '11', :status => true, :latitude => 38.445724, :longitude => 141.267375, :disaster_code => "20130108151823978961")
Staff.create(:name => '小林', :agent_id => 22, :destination_code => '12', :status => true, :latitude => 38.454513, :longitude => 141.255187, :disaster_code => "20130108151823978961")
Staff.create(:name => '中村', :agent_id => 23, :destination_code => '7', :status => true, :latitude => 38.45705, :longitude => 141.280636, :disaster_code => "20130108151823978961")
Staff.create(:name => '伊藤', :agent_id => 24, :destination_code => '17', :status => true, :latitude => 38.457353, :longitude => 141.245198, :disaster_code => "20130108151823978961")
Staff.create(:name => '渡邊', :agent_id => 25, :destination_code => '17', :status => true, :latitude => 38.431673, :longitude => 141.251721, :disaster_code => "20130108151823978961")

Staff.create(:name => '斉藤', :agent_id => 26, :destination_code => '2', :status => true, :latitude => 38.426328, :longitude => 141.296214, :disaster_code => "20130108151823978961")
Staff.create(:name => '山口', :agent_id => 27, :destination_code => '2', :status => true, :latitude => 38.430345, :longitude => 141.302973, :disaster_code => "20130108151823978961")
Staff.create(:name => '松本', :agent_id => 28, :destination_code => '19', :status => true, :latitude => 38.446447, :longitude => 141.33458, :disaster_code => "20130108151823978961")
Staff.create(:name => '木村', :agent_id => 29, :destination_code => '19', :status => true, :latitude => 38.448867, :longitude => 141.337649, :disaster_code => "20130108151823978961")
Staff.create(:name => '清水', :agent_id => 30, :destination_code => '5', :status => true, :latitude => 38.432312, :longitude => 141.297973, :disaster_code => "20130108151823978961")

Staff.create(:name => '山崎', :agent_id => 31, :destination_code => '5', :status => true, :latitude => 38.430732, :longitude => 141.29939, :disaster_code => "20130108151823978961")
Staff.create(:name => '池田', :agent_id => 32, :destination_code => '5', :status => true, :latitude => 38.429354, :longitude => 141.303574, :disaster_code => "20130108151823978961")
Staff.create(:name => '阿部', :agent_id => 33, :destination_code => '12', :status => true, :latitude => 38.446783, :longitude => 141.254779, :disaster_code => "20130108151823978961")
Staff.create(:name => '森', :agent_id => 34, :destination_code => '6', :status => true, :latitude => 38.423369, :longitude => 141.285785, :disaster_code => "20130108151823978961")
Staff.create(:name => '橋本', :agent_id => 35, :destination_code => '10', :status => true, :latitude => 38.435018, :longitude => 141.308329, :disaster_code => "20130108151823978961")

Staff.create(:name => '山下', :agent_id => 36, :destination_code => '10', :status => true, :latitude => 38.436455, :longitude => 141.306365, :disaster_code => "20130108151823978961")
Staff.create(:name => '石川', :agent_id => 37, :destination_code => '1', :status => true, :latitude => 38.433489, :longitude => 141.30999, :disaster_code => "20130108151823978961")
Staff.create(:name => '中島', :agent_id => 38, :destination_code => '15', :status => true, :latitude => 38.441691, :longitude => 141.299754, :disaster_code => "20130108151823978961")
Staff.create(:name => '前田', :agent_id => 39, :destination_code => '8', :status => true, :latitude => 38.429471, :longitude => 141.287416, :disaster_code => "20130108151823978961")
Staff.create(:name => '小川', :agent_id => 40, :destination_code => '4', :status => true, :latitude => 38.429606, :longitude => 141.28939, :disaster_code => "20130108151823978961")

Staff.create(:name => '岡田', :agent_id => 41, :destination_code => '4', :status => true, :latitude => 38.433539, :longitude => 141.300248, :disaster_code => "20130108151823978961")
Staff.create(:name => '後藤', :agent_id => 42, :destination_code => '4', :status => true, :latitude => 38.429942, :longitude => 141.301986, :disaster_code => "20130108151823978961")
Staff.create(:name => '長谷川', :agent_id => 43, :destination_code => '4', :status => true, :latitude => 38.42621, :longitude => 141.295978, :disaster_code => "20130108151823978961")
Staff.create(:name => '村上', :agent_id => 44, :destination_code => '11', :status => true, :latitude => 38.449304, :longitude => 141.273082, :disaster_code => "20130108151823978961")
Staff.create(:name => '遠藤', :agent_id => 45, :destination_code => '7', :status => true, :latitude => 38.454597, :longitude => 141.278576, :disaster_code => "20130108151823978961")
