# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130214030135) do



  create_table "agents", :force => true do |t|
    t.string   "name",         :limit => 64
    t.string   "mail_address", :limit => 256
    t.string   "department",   :limit => 64
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "notes", :force => true do |t|
    t.string   "note",       :limit => 40
    t.integer  "staff_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "staffs", :force => true do |t|
    t.string   "name",             :limit => 64
    t.integer  "agent_id"
    t.string   "destination_code", :limit => 20
    t.boolean  "status"
    t.text     "reason"
    t.decimal  "latitude",                       :precision => 10, :scale => 6
    t.decimal  "longitude",                      :precision => 10, :scale => 6
    t.string   "disaster_code",    :limit => 20
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                :default => "", :null => false
    t.string   "email",                :default => "", :null => false
    t.string   "encrypted_password",   :default => "", :null => false
    t.string   "agent_id",             :default => ""
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email", "provider", "uid"], :name => "index_users_on_email_and_provider_and_uid", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  set_column_comment 'agents', 'id', 'ID'
  set_column_comment 'agents', 'name', '職員名'
  set_column_comment 'agents', 'mail_address', 'メールアドレス'
  set_column_comment 'agents', 'department', '部署'
  set_column_comment 'agents', 'created_at', '作成時刻'
  set_column_comment 'agents', 'updated_at', '更新時刻'

  set_column_comment 'notes', 'id', 'ID'
  set_column_comment 'notes', 'note', '備考'
  set_column_comment 'notes', 'staff_id', '職員ID'
  set_column_comment 'notes', 'created_at', '作成時刻'
  set_column_comment 'notes', 'updated_at', '更新時刻'

  set_column_comment 'staffs', 'id', 'ID'
  set_column_comment 'staffs', 'name', '職員名'
  set_column_comment 'staffs', 'agent_id', '職員マスタID'
  set_column_comment 'staffs', 'destination_code', '参集場所コード'
  set_column_comment 'staffs', 'status', '参集先に向かうのが困難'
  set_column_comment 'staffs', 'reason', '理由'
  set_column_comment 'staffs', 'latitude', '緯度'
  set_column_comment 'staffs', 'longitude', '経度'
  set_column_comment 'staffs', 'disaster_code', '災害番号'
  set_column_comment 'staffs', 'created_at', '作成時刻'
  set_column_comment 'staffs', 'updated_at', '更新時刻'

  set_column_comment 'users', 'id', 'ID'
  set_column_comment 'users', 'login', 'ログイン名'
  set_column_comment 'users', 'email', '電子メール'
  set_column_comment 'users', 'encrypted_password', 'パスワード'
  set_column_comment 'users', 'agent_id', '職員マスタID'
  set_column_comment 'users', 'sign_in_count', 'サインイン回数'
  set_column_comment 'users', 'current_sign_in_at', '最新サインイン時刻'
  set_column_comment 'users', 'last_sign_in_at', '最終サインイン時刻'
  set_column_comment 'users', 'current_sign_in_ip', '最新サインインIP'
  set_column_comment 'users', 'last_sign_in_ip', '最終サインインIP'
  set_column_comment 'users', 'confirmation_token', '確認トークン'
  set_column_comment 'users', 'confirmed_at', '確認時刻'
  set_column_comment 'users', 'confirmation_sent_at', '送信確認時刻'
  set_column_comment 'users', 'unconfirmed_email', '未確認メール'
  set_column_comment 'users', 'created_at', '作成時刻'
  set_column_comment 'users', 'updated_at', '更新時刻'
  set_column_comment 'users', 'provider', '認可プロバイダ名'
  set_column_comment 'users', 'uid', '認可プロバイダのユーザ識別子'

end
