class CreateRoboscoutQueries < ActiveRecord::Migration[6.0]
  def change
    create_table :roboscout_queries do |t|
      t.string :query

      t.timestamps
    end
  end
end
