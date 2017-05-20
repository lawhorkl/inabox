class CreateServers < ActiveRecord::Migration[5.0]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :hostname
      t.integer :ram_capacity
      t.integer :current_ram_usage
      t.integer :cores_available
      t.integer :current_core_usage

      t.timestamps
    end
  end
end
