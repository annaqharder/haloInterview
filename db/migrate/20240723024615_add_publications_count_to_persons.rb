class AddPublicationsCountToPersons < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :publications_count, :integer
  end
end
