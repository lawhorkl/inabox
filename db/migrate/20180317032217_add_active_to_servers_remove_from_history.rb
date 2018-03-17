class AddActiveToServersRemoveFromHistory < ActiveRecord::Migration[5.0]
  def change
    remove_column :server_histories, :active, :boolean
    add_column :servers, :active, :boolean
  end
end
