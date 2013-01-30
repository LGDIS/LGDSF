# -*- coding:utf-8 -*-
class AddMailIdToStaffs < ActiveRecord::Migration
  def change
    add_column :staffs, :mail_id, :string

    set_column_comment(:staffs, :mail_id, "災害番号")
  end
end
