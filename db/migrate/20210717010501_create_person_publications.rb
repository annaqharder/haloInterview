class CreatePersonPublications < ActiveRecord::Migration[6.0]
  def change
    create_table :person_publications do |t|
      t.references :person, null: false, foreign_key: true
      t.references :publication, null: false, foreign_key: true

      t.timestamps
    end
  end
end

