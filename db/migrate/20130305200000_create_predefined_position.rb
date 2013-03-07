# -*- coding:utf-8 -*-
class CreatePredefinedPosition < ActiveRecord::Migration
  def change
    create_table :predefined_positions do |t|
      t.integer :id
      t.string  :agent_id, :null => false
      t.string  :position_code, :null => false

      t.timestamps
    end

    set_table_comment(:predefined_positions, "職員参集場所マスタ")
    set_column_comment(:predefined_positions, :id,            "ID")
    set_column_comment(:predefined_positions, :agent_id,      "職員マスタID")
    set_column_comment(:predefined_positions, :position_code, "参集場所コード")
    set_column_comment(:predefined_positions, :created_at,    "作成時刻")
    set_column_comment(:predefined_positions, :updated_at,    "更新時刻")
  end
end
