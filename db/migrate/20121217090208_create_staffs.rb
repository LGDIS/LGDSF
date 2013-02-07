# -*- coding:utf-8 -*-
class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.integer :id
      t.string  :name, :limit => 64
      t.integer :agent_id
      t.string  :destination_code, :limit => 20, :null => false
      t.boolean :status
      t.text    :reason
      t.decimal :latitude,  :precision => 10, :scale => 6
      t.decimal :longitude, :precision => 10, :scale => 6
      t.string  :disaster_code, :limit => 20, :null => false

      t.timestamps
    end

    set_column_comment(:staffs, :id,          "ID")
    set_column_comment(:staffs, :name,        "職員名")
    set_column_comment(:staffs, :agent_id,    "職員マスタID")
    set_column_comment(:staffs, :destination_code, "参集場所コード")
    set_column_comment(:staffs, :status,      "参集先に向かうのが困難")
    set_column_comment(:staffs, :reason,      "理由")
    set_column_comment(:staffs, :latitude,    "緯度")
    set_column_comment(:staffs, :longitude,   "経度")
    set_column_comment(:staffs, :disaster_code, "災害番号")
    set_column_comment(:staffs, :created_at,  "作成時刻")
    set_column_comment(:staffs, :updated_at,  "更新時刻")
  end
end
