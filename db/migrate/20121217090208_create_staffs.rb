class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.integer :id
      t.string  :name
      t.integer :agent_id
      t.string  :destination
      t.boolean :status
      t.text    :reason
      t.decimal :latitude,  :precision => 10, :scale => 6
      t.decimal :longitude, :precision => 10, :scale => 6

      t.timestamps
    end
  end
end
