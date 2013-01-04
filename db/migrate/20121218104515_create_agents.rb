class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.integer :id
      t.string :name
      t.string :mail_address

      t.timestamps
    end
  end
end
