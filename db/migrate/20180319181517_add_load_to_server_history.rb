class AddLoadToServerHistory < ActiveRecord::Migration[5.0]
  def change
    add_column :server_histories, :cpu_load_one, :float, default: 5
    add_column :server_histories, :cpu_load_five, :float, default: 5
    add_column :server_histories, :cpu_load_fifteen, :float, default: 5
  end
end
