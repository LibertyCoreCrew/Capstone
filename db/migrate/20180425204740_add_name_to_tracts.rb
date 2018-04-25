class AddNameToTracts < ActiveRecord::Migration[5.1]
  def change
    add_column :tracts, :name, :string
  end
end
