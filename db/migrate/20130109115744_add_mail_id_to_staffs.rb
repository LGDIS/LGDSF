class AddMailIdToStaffs < ActiveRecord::Migration
  def change
    add_column :staffs, :mail_id, :string
  end
end
