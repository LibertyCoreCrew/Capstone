class DropAdmins < ActiveRecord::Migration[5.1]
  def change
    drop_table :admins if ActiveRecord::Base.connection.table_exists? 'admins'
  end
end
