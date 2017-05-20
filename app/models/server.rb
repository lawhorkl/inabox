class Server < ApplicationRecord
  validates :name, :hostname, :ram_capacity, :current_ram_usage, :cores_available, :current_core_usage, presence: true
end
