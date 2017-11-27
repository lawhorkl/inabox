class AddBlockSizeToServerHistory < ActiveRecord::Migration[5.0]
  def change
    add_column :server_histories, :block_size, :int
  end
end
