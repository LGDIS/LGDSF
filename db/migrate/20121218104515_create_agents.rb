# -*- coding:utf-8 -*-
class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.integer :id
      t.string :name, :limit => 64
      t.string :mail_address, :limit => 256

      t.timestamps
    end

    set_column_comment(:agents, :id,           "ID")
    set_column_comment(:agents, :name,         "職員名")
    set_column_comment(:agents, :mail_address, "メールアドレス")
    set_column_comment(:agents, :created_at,   "作成時刻")
    set_column_comment(:agents, :updated_at,   "更新時刻")
  end
end
