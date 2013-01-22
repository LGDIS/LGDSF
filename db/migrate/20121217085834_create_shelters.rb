class CreateShelters < ActiveRecord::Migration
  def change
    create_table :shelters do |t|
      t.integer :id
      t.string  :name
      t.decimal :latitude, :precision => 10, :scale => 6
      t.decimal :longitude, :precision => 10, :scale => 6

      t.timestamps
    end

    set_column_comment(:shelters, :id,         "ID")
    set_column_comment(:shelters, :name,       "避難所名")
    set_column_comment(:shelters, :latitude,   "緯度")
    set_column_comment(:shelters, :longitude,  "経度")
    set_column_comment(:shelters, :created_at, "作成時刻")
    set_column_comment(:shelters, :updated_at, "更新時刻")
  end
end
