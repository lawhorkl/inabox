class QueryApiJob < ApplicationJob
  queue_as :default
  
  def perform(*args)
    puts 'job started'
    @server = Server.find(args[0])
    server_stats = get_stats_from_server
    @server.active = true
    @server.ram_capacity = server_stats[:ram_stats][:ram_capacity]
    @server.free_ram = server_stats[:ram_stats][:ram_free]
    @server.current_ram_usage = @server.ram_capacity - @server.free_ram
    # byebug
    @server.cores_available = server_stats[:cpu_stats][:cpu_cores]
    # @server.current_core_usage = server_stats
    puts 'success!' if @server.save
    queue_next_query
  rescue Errno::ECONNREFUSED
    puts 'api down'
    @server.active = false
    @server.save
    queue_next_query
  end

  def get_stats_from_server
    puts 'get stats from server called'
    HTTParty.get("#{@server.address}/stats").parsed_response.deep_symbolize_keys
  end

  def queue_next_query
    puts "next query queued for #{@server.name}" if QueryApiJob.set(wait: 30.seconds).perform_later(@server.id)
  end
end
