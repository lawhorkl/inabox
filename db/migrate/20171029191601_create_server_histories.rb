class CreateServerHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :server_histories do |t|
      t.belongs_to :server, index: true
      t.string :name
      t.string :hostname
      t.integer :port
      t.bigint :ram_capacity
      t.bigint :current_ram_usage
      t.bigint :free_ram
      t.bigint :cores_available
      t.bigint :current_core_usage
      t.boolean :active

      t.timestamps
    end
  end
end
