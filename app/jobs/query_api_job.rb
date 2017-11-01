class QueryApiJob < ApplicationJob
  queue_as :default
  
  def perform(*args)
    puts 'job started'
    @server = Server.find(args[0])
    @server.update_and_save_history get_stats_from_server
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
