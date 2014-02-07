class AddMasterToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :master, :boolean, default: false
  end
end
