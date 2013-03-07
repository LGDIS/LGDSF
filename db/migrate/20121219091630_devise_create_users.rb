# -*- coding:utf-8 -*-
class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :login,              :null => false, :default => "", :unique => true
      t.string :email,              :null => false, :default => "", :unique => true
      t.string :encrypted_password, :null => false, :default => ""
      t.string :agent_id, :null => true, :default => ""

      ## Recoverable
      #t.string   :reset_password_token
      #t.datetime :reset_password_sent_at

      ## Rememberable
      #t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      # t.string :authentication_token


      t.timestamps
    end

    add_index :users, :login,                :unique => true
    add_index :users, :email,                :unique => true
    # add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true

    set_table_comment(:users, "ユーザ")
    set_column_comment(:users, :id,                     "ID")
    set_column_comment(:users, :login,                  "ログイン名")
    set_column_comment(:users, :email,                  "電子メール")
    set_column_comment(:users, :encrypted_password,     "パスワード")
    set_column_comment(:users, :agent_id,               "職員マスタID")
    #set_column_comment(:users, :reset_password_token,   "リセットパスワードトークン")
    #set_column_comment(:users, :reset_password_sent_at, "リセットパスワード送信時刻")
    #set_column_comment(:users, :remember_created_at,    "アウカント作成時刻")
    set_column_comment(:users, :sign_in_count,          "サインイン回数")
    set_column_comment(:users, :current_sign_in_at,     "最新サインイン時刻")
    set_column_comment(:users, :last_sign_in_at,        "最終サインイン時刻")
    set_column_comment(:users, :current_sign_in_ip,     "最新サインインIP")
    set_column_comment(:users, :last_sign_in_ip,        "最終サインインIP")
    set_column_comment(:users, :confirmation_token,     "確認トークン")
    set_column_comment(:users, :confirmed_at,           "確認時刻")
    set_column_comment(:users, :confirmation_sent_at,   "送信確認時刻")
    set_column_comment(:users, :unconfirmed_email,      "未確認メール")
    set_column_comment(:users, :created_at,             "作成時刻")
    set_column_comment(:users, :updated_at,             "更新時刻")
  end
end
