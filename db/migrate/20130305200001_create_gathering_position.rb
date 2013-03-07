# -*- coding:utf-8 -*-
class CreateGatheringPosition < ActiveRecord::Migration
  def change
    create_table :gathering_positions do |t|
      t.integer :id
      t.string  :position_code
      t.string  :name, :limit => 30
      t.string  :area_dai_code, :limit => 2
      t.string  :address_code
      t.string  :address
      t.string  :latitude
      t.string  :longitude
      t.string  :remarks, :limit => 256

      t.timestamps
    end

    set_table_comment(:gathering_positions, "参集場所")
    set_column_comment(:gathering_positions, :id,            "ID")
    set_column_comment(:gathering_positions, :position_code, "参集場所コード")
    set_column_comment(:gathering_positions, :name,          "名称")
    set_column_comment(:gathering_positions, :area_dai_code, "地区コード（大分類）")
    set_column_comment(:gathering_positions, :address_code,  "住所コード")
    set_column_comment(:gathering_positions, :address,       "住所")
    set_column_comment(:gathering_positions, :latitude,      "緯度")
    set_column_comment(:gathering_positions, :longitude,     "経度")
    set_column_comment(:gathering_positions, :remarks,       "備考")
    set_column_comment(:gathering_positions, :created_at,    "作成時刻")
    set_column_comment(:gathering_positions, :updated_at,    "更新時刻")
  end
end
