class AddPortToServers < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :port, :integer
  end
end
