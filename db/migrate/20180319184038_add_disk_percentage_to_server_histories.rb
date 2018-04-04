class AddDiskPercentageToServerHistories < ActiveRecord::Migration[5.0]
  def change
    add_column :server_histories, :disk_percentage, :int, default: 20
  end
end
