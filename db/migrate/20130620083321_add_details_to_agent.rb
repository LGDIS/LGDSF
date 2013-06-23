class AddDetailsToAgent < ActiveRecord::Migration
  def change
    add_column :agents, :path, :string, :limit => 64
    set_column_comment(:agents, :path, "個人URL用文字")
  end
end