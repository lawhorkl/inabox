class Server < ApplicationRecord
  validates :name, :hostname, :port, presence: true

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

  def reachable?
    Net::Ping::External.new(self.ip).ping?  
  end
end
