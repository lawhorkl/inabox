class AddConversionsToServerHistories < ActiveRecord::Migration[5.0]
  def change
    add_column :server_histories, :usage_in_gb, :integer
    add_column :server_histories, :usage_in_mb, :integer
    add_column :server_histories, :usage_in_kb, :integer
  end
end
