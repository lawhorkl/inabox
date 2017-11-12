class Server < ApplicationRecord
  validates :name, :hostname, :port, presence: true
  has_many :server_histories, dependent: :destroy

  def address 
    if self.hostname.include?('http')
      "#{self.hostname}:#{self.port}"
    else
      "http://#{self.hostname}:#{self.port}"
    end
  end

  def ip
    self.hostname.gsub('http://', '')
  end

  def active?
    self.active  
  end

  def update_and_save_history(current_stats)
    self.server_histories.create current_stats
  end

  def convert_usage_to_gb
    self.ram_capacity / (1024*1024*1024)
  end

  def convert_usage_to_mb
    self.ram_capacity / (1024*1024)
  end

  def convert_usage_to_kb
    self.ram_capacity / (1024)
  end

end
