class AddPredefinedPositionIdToStaffs < ActiveRecord::Migration
  def change
    add_column :staffs, :predefined_position_id, :integer
  end
end
