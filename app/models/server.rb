class Server < ApplicationRecord
  validates :name, :hostname, :port, presence: true
  after_initialize :set_active

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

  private

  def set_active
    self.active = true if self.active.nil?
  end
end
