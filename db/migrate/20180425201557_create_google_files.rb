class CreateGoogleFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :google_files do |t|
      
      t.integer  :project_id
      t.integer  :tract_id
      
      t.string :google_id
      t.string :web_view_link
      t.string :name
      t.datetime :last_change

      t.timestamps
    end
  end
end
