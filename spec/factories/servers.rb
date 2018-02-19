FactoryBot.define do
  factory :server_history do
    ram_capacity 4096567567
    current_ram_usage 2304305621
    free_ram 2000000000
    cores_available 2
    active true
  end
  
  factory :server do
    transient do
      stat_count 1
    end

    after(:create) do |server, eval|
      create_list(:server_history, eval.stat_count, server: server)
    end
    sequence(:name) { |n| "Server #{n}" }
    hostname '127.0.0.1'
    port 3000
  end

end
