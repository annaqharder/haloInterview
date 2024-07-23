class CreateRoboscoutQueryPeople < ActiveRecord::Migration[6.0]
  def change
    create_table :roboscout_query_people do |t|
      t.references :roboscout_query, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
