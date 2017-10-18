class AddFreeRamToServers < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :free_ram, :bigint
  end
end
