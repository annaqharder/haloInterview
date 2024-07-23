class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :affiliation
      t.string :openalex_id

      t.timestamps
    end
  end
end
