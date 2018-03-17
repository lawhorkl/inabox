class QueryApiJob < ApplicationJob
  queue_as :default
  
  def perform(*args)
    @server = Server.find(args[0])
    puts "Querying: #{@server.name} (ID: #{@server.id})"
    @server.server_histories.create get_stats_from_server
    @server.active = true
    @server.save
    puts "Stats received from server #{@server.name}" 
    queue_next_query
  rescue Net::OpenTimeout
    puts "Server #{@server.name} (ID: #{@server.id}) physically down."
    @server.active = false
    @server.save
    queue_next_query
  rescue Errno::ECONNREFUSED
    puts "Server accessible but API is down on #{@server.name} (ID: #{@server.id})."
    @server.active = false
    @server.save
    queue_next_query
  end

  def get_stats_from_server
    HTTParty.get("#{@server.address}/stats", {timeout: 5}).parsed_response.deep_symbolize_keys
  end

  def queue_next_query
    if QueryApiJob.set(wait: 30.seconds).perform_later(@server.id)
      puts "Next query successfully queued for #{@server.name}"
    else 
      puts "Queueing next query for #{@server.name} (ID: #{@server.id}) failed."
    end
  end
end
