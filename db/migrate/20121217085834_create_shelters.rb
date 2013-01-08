class CreateShelters < ActiveRecord::Migration
  def change
    create_table :shelters do |t|
      t.integer :id
      t.string  :name
      t.decimal :latitude, :precision => 10, :scale => 6
      t.decimal :longitude, :precision => 10, :scale => 6

      t.timestamps
    end
  end
end
