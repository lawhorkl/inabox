class QueryApiJob < ApplicationJob
  queue_as :default
  
  def perform(*args)
    @server = Server.find(args[0])
    puts "Querying: #{@server.name} (ID: #{@server.id})"
    @server.server_histories.create get_stats_from_server
    @server.active = true
    @server.save
    
    puts "Stats received from server #{@server.name}" 
  rescue Net::OpenTimeout
    puts "Server #{@server.name} (ID: #{@server.id}) physically down."
    @server.active = false
    @server.save
  rescue Errno::ECONNREFUSED
    puts "Server accessible but API is down on #{@server.name} (ID: #{@server.id})."
    @server.active = false
    @server.save
  end

  def get_stats_from_server
    HTTParty.get("#{@server.address}/stats", {timeout: 5}).parsed_response.deep_symbolize_keys
  end

end
