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
    byebug
  end

  def self.not_tracked?(attribute)
    %w[
      id
      name
      hostname
      port
      updated_at
      created_at
    ].include? attribute
  end
end
