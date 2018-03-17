class Server < ApplicationRecord
  validates :name, :hostname, :port, presence: true
  has_many :server_histories, dependent: :destroy
  after_initialize :populate_latest_stats
  attr_accessor :latest_stats

  @@no_data_str = "No data available."

  def address 
    if self.hostname.include?('http')
      "#{self.hostname}:#{self.port}"
    else
      "http://#{self.hostname}:#{self.port}"
    end
  end

  def active?
    self.active
  end

  def get_stat(stat)
    return @@no_data_str if @latest_stats.nil?
    eval "@latest_stats.#{stat}"
  end

  def populate_latest_stats
    @latest_stats = self.server_histories.last
  end

  def self.no_data_str
    @@no_data_str
  end
end
