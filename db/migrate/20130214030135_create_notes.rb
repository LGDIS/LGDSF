# -*- coding:utf-8 -*-
class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :id
      t.string  :note, :limit => 40
      t.integer :staff_id

      t.timestamps
    end

    set_table_comment(:notes, "肩代わり報告")
    set_column_comment(:notes, :id,          "ID")
    set_column_comment(:notes, :note,        "肩代わり報告内容")
    set_column_comment(:notes, :staff_id,    "職員ID")
    set_column_comment(:notes, :created_at,  "作成時刻")
    set_column_comment(:notes, :updated_at,  "更新時刻")
  end
end
