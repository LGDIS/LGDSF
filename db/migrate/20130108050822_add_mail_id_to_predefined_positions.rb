class AddMailIdToPredefinedPositions < ActiveRecord::Migration
  def change
    add_column :predefined_positions, :mail_id, :string
  end
end
