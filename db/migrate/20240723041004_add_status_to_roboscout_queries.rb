class AddStatusToRoboscoutQueries < ActiveRecord::Migration[6.1]
  def change
    add_column :roboscout_queries, :status, :integer, default: 0
  end
end
