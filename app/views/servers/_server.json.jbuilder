json.extract! server, :id, :name, :hostname, :ram_capacity, :current_ram_usage, :cores_available, :current_core_usage, :created_at, :updated_at
json.url server_url(server, format: :json)
