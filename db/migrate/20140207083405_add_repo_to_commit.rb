class AddRepoToCommit < ActiveRecord::Migration
  def change
    add_reference :commits, :repo, index: true
  end
end
