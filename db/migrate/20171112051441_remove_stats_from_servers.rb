class RemoveStatsFromServers < ActiveRecord::Migration[5.0]
  def change
    remove_column :servers, :ram_capacity, :bigont
    remove_column :servers, :current_ram_usage, :bigint
    remove_column :servers, :cores_available, :bigint
    remove_column :servers, :current_core_usage
    remove_column :servers, :free_ram, :bigint
    remove_column :servers, :active, :boolean
  end
end
