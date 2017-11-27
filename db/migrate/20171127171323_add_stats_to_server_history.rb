class AddStatsToServerHistory < ActiveRecord::Migration[5.0]
  def change
    add_column :server_histories, :disk_count, :int
    add_column :server_histories, :filesystem, :string
    add_column :server_histories, :storage_capacity, :bigint
    add_column :server_histories, :free_storage, :bigint
    add_column :server_histories, :mount_point, :string
  end
end
