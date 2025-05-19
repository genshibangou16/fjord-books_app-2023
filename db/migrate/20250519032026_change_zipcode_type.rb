class ChangeZipcodeType < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :zipcode, :string, :limit => 7
  end
end
