class Server < ApplicationRecord
  validates :name, :hostname, :port, presence: true
  has_paper_trail

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
end
