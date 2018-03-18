namespace :query do
  namespace :manager do
    
    desc "start InaBox query manager without clearing redis or server history"
    task start: :environment do
      puts 'InaBox Query Manager Started.'
      
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

    desc "clears redis queues for InaBox"
    task clean: :environment do
      puts 'Clearing Redis Queue'
      Sidekiq.redis { |r| puts r.flushall }
    end
    
    desc "clears redis queues and starts InaBox query manager" 
    task clean_start: :environment do
      Rake::Task["query:manager:clean"].invoke
      Rake::Task["query:manager:start"].invoke
    end

    desc "clears redis queues, server history, and starts InaBox query manager"
    task fresh_start: :environment do
      puts "Deleting all server history"
      puts "All server history deleted" if ServerHistory.delete_all
      Rake::Task["query:manager:clean_start"].invoke
    end
  end
end
