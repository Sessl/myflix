class AddTokenSetTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_set_time, :datetime
  end
end
