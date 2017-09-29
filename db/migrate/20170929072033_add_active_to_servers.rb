class AddActiveToServers < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :active, :boolean
  end
end
