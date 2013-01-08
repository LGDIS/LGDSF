class CreatePredefinedPositions < ActiveRecord::Migration
  def change
    create_table :predefined_positions do |t|
      t.integer :id
      t.integer :agent_id
      t.integer :shelter_id

      t.timestamps
    end
  end
end
