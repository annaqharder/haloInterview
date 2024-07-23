class CreatePublications < ActiveRecord::Migration[6.0]
  def change
    create_table :publications do |t|
      t.string :title
      t.text :abstract
      t.date :publication_date
      t.string :openalex_id
      t.integer :position

      t.timestamps
    end
  end
end
