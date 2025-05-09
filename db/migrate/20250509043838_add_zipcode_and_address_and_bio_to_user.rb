class AddZipcodeAndAddressAndBioToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :zipcode, :text, :limit => 7
    add_column :users, :address, :text
    add_column :users, :bio, :text
  end
end
