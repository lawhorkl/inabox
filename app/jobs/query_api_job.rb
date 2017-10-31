class QueryApiJob < ApplicationJob
  queue_as :default
  
  def perform(*args)
    puts 'job started'
    @server = Server.find(args[0])
    server_stats = get_stats_from_server
    old_stats = {}
    Server.attribute_names.each do |attr|
      old_stats[attr.to_sym] = @server.send attr unless Server.not_tracked? attr
    end
    @server.update_and_save_history(old_stats, server_stats)
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
