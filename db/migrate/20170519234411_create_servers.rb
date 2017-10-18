class CreateServers < ActiveRecord::Migration[5.0]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :hostname
      t.bigint :ram_capacity
      t.bigint :current_ram_usage
      t.bigint :cores_available
      t.bigint :current_core_usage

      t.timestamps
    end
  end
end
