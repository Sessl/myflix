class AddTokenSetTimeToInvitations < ActiveRecord::Migration
  def change
  	add_column :invitations, :token_set_time, :datetime
  end
end
