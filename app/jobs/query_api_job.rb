class QueryApiJob < ApplicationJob
  @queue = :default

  def self.perform(*args)
    puts 'job started'
    @server = Server.find(args[0])
    server_stats = get_stats_from_server
    @server.active = true
    @server.ram_capacity = server_stats[:ram_stats][:ram_capacity]
    @server.free_ram = server_stats[:ram_stats][:ram_free]
    @server.current_ram_usage = @server.ram_capacity - @server.free_ram
    # @server.cores_available = server_stats
    # @server.current_core_usage = server_stats
    puts 'success!' if @server.save
  rescue Errno::ECONNREFUSED
    puts 'api down'
    @server.active = false
    @server.save
  end

  def self.get_stats_from_server
    puts 'get stats from server called'
    HTTParty.get("#{@server.address}/stats").parsed_response.deep_symbolize_keys
  end
end
