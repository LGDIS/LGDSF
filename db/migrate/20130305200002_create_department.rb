# -*- coding:utf-8 -*-
class CreateDepartment < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :id
      t.string  :department_code
      t.string  :name
      t.string  :remarks, :limit => 256

      t.timestamps
    end

    set_table_comment(:departments, "部署マスタ")
    set_column_comment(:departments, :id,              "ID")
    set_column_comment(:departments, :department_code, "部署コード")
    set_column_comment(:departments, :name,            "部署名称")
    set_column_comment(:departments, :remarks,         "備考")
    set_column_comment(:departments, :created_at,      "作成時刻")
    set_column_comment(:departments, :updated_at,      "更新時刻")
  end
end
