class CreateKeydates < ActiveRecord::Migration[5.1]
  def change
    create_table :keydates do |t|
      
      t.integer  :project_id
      t.integer  :tract_id
      t.string   :name
      t.date     :date
      t.text     :comments

      t.timestamps
    end
  end
end
