class CreateTracts < ActiveRecord::Migration[5.1]
  def change
    create_table :tracts do |t|
      
      t.integer  :project_id
      t.integer  :user_id
      t.string   :owner_name
      t.string   :parcel_address
      t.string   :owner_phone
      t.string   :owner_email
      t.float    :payment_amount
      t.text     :remarks

      t.timestamps
    end
  end
end
