unless $PROGRAM_NAME.include?('sidekiq') || defined?(Rails::Console)
  Thread.new do
    puts 'InaBox Query Manager Started.'
    puts 'Clearing Redis Queue' if Sidekiq.redis { |r| puts r.flushall }
    
    while true do
      puts 'Queueing Queries for all servers'
      if Server.queue_all_servers
        puts 'All queries queued... Sleeping.'
      else 
        puts 'There are no servers to query... Sleeping.'
      end
      sleep 30
    end
  end
end
