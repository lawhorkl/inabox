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

  def update_and_save_history(current_stats)
    self.server_histories.create current_stats
  end
  
  def active?
    self.server_histories.last.active
  end
end
