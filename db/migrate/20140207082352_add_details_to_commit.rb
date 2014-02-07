class AddDetailsToCommit < ActiveRecord::Migration
  def change
    add_reference :commits, :author, index: true
    add_reference :commits, :committer, index: true
    add_column :commits, :timestamp, :datetime
    add_column :commits, :message, :text
  end
end
