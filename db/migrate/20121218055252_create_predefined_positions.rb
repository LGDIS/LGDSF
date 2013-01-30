# -*- coding:utf-8 -*-
class CreatePredefinedPositions < ActiveRecord::Migration
  def change
    create_table :predefined_positions do |t|
      t.integer :id
      t.integer :agent_id
      t.integer :shelter_id

      t.timestamps
    end

    set_column_comment(:predefined_positions, :id,         "ID")
    set_column_comment(:predefined_positions, :agent_id,   "職員マスタID")
    set_column_comment(:predefined_positions, :shelter_id, "避難所マスタID")
    set_column_comment(:predefined_positions, :created_at, "作成時刻")
    set_column_comment(:predefined_positions, :updated_at, "更新時刻")
  end
end
